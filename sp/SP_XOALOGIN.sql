USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_XOALOGIN]    Script Date: 12/20/2024 12:55:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_XOALOGIN]
    @LGNAME NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem login có tồn tại hay không
    IF NOT EXISTS (SELECT 1 FROM sys.syslogins WHERE name = @LGNAME)
    BEGIN
        PRINT N'Login không tồn tại.';
        RETURN 1; -- Mã lỗi 1: Login không tồn tại
    END

    -- Lấy tên User từ login
    DECLARE @USERNAME NVARCHAR(50);
    SELECT @USERNAME = name FROM sys.sysusers WHERE sid = SUSER_SID(@LGNAME);

    -- Ngắt kết nối các phiên đang sử dụng login
    BEGIN TRY
        -- Vô hiệu hóa login
        DECLARE @SQL NVARCHAR(MAX);
        SET @SQL = 'ALTER LOGIN [' + @LGNAME + '] DISABLE';
        EXEC(@SQL);

        -- Tìm tất cả session_id liên quan đến login
        DECLARE @SPID INT;
        DECLARE @SPID_TABLE TABLE (SPID INT);
        INSERT INTO @SPID_TABLE (SPID)
        SELECT session_id
        FROM sys.dm_exec_sessions
        WHERE login_name = @LGNAME;

        -- Ngắt kết nối từng session
        WHILE EXISTS (SELECT 1 FROM @SPID_TABLE)
        BEGIN
            SELECT TOP 1 @SPID = SPID FROM @SPID_TABLE;
            SET @SQL = 'KILL ' + CAST(@SPID AS NVARCHAR(10));
            EXEC(@SQL);

            DELETE FROM @SPID_TABLE WHERE SPID = @SPID;
        END
    END TRY
    BEGIN CATCH
        PRINT N'Không thể ngắt kết nối login do lỗi: ' + ERROR_MESSAGE();
        RETURN 2; -- Mã lỗi 2: Không thể ngắt kết nối
    END CATCH

    -- Kiểm tra và xóa các quyền đã được cấp cho User
    IF EXISTS (SELECT 1 FROM sys.sysmembers WHERE memberuid = (SELECT uid FROM sys.sysusers WHERE name = @USERNAME))
    BEGIN
        DECLARE @ROLE NVARCHAR(50);
        SELECT TOP 1 @ROLE = name
        FROM sys.sysusers
        WHERE uid = (SELECT groupuid FROM sys.sysmembers WHERE memberuid = (SELECT uid FROM sys.sysusers WHERE name = @USERNAME));

        EXEC sp_droprolemember @ROLE, @USERNAME;
    END

    -- Xóa quyền database user
    IF EXISTS (SELECT 1 FROM sys.sysusers WHERE name = @USERNAME)
    BEGIN
        EXEC sp_revokedbaccess @USERNAME;
    END

    -- Xóa tài khoản login
    BEGIN TRY
        EXEC sp_droplogin @LGNAME;
    END TRY
    BEGIN CATCH
        PRINT N'Không thể xóa login do lỗi: ' + ERROR_MESSAGE();
        RETURN 3; -- Mã lỗi 3: Không thể xóa login
    END CATCH

    PRINT N'Login đã được xóa thành công.';
    RETURN 0; -- Thành công
END

GO

