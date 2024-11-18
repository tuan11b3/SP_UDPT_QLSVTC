USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_REPORT_IN_DSSV]    Script Date: 11/16/2024 3:14:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_REPORT_IN_DSSV]
    @MAKHOA NVARCHAR(10),  -- Mã khoa
    @MALOP NVARCHAR(10)     -- Mã lớp
AS
BEGIN
    DECLARE @UserRole NVARCHAR(50);  -- Biến để lưu quyền của người dùng
    DECLARE @IsSysAdmin BIT;          -- Biến để kiểm tra quyền sysadmin

    -- Kiểm tra xem người dùng có phải là sysadmin (sa) không
    SET @IsSysAdmin = IS_SRVROLEMEMBER('sysadmin');  -- Trả về 1 nếu là sysadmin, 0 nếu không phải

    -- Nếu là sysadmin, cho phép truy vấn tất cả dữ liệu
    IF @IsSysAdmin = 1
    BEGIN
        -- Truy vấn tất cả sinh viên từ tất cả các site mà không cần kiểm tra quyền
        SELECT sv.MASV, sv.HO, sv.TEN, sv.PHAI, sv.DIACHI, sv.NGAYSINH
        FROM SINHVIEN sv
        JOIN LOP l ON sv.MALOP = l.MALOP
        WHERE l.MAKHOA = @MAKHOA AND l.MALOP = @MALOP;

        -- Truy vấn từ site chủ nếu lớp không có trong site phân mảnh
        IF NOT EXISTS (SELECT 1 FROM LOP WHERE MALOP = @MALOP)
        BEGIN
            IF EXISTS (SELECT MALOP FROM LINK0.QLSVTC.dbo.LOP WHERE MALOP = @MALOP)
            BEGIN
                SELECT sv.MASV, sv.HO, sv.TEN, sv.PHAI, sv.DIACHI, sv.NGAYSINH
                FROM LINK0.QLSVTC.dbo.SINHVIEN sv
                JOIN LINK0.QLSVTC.dbo.LOP l ON sv.MALOP = l.MALOP
                WHERE l.MALOP = @MALOP;
            END
            ELSE
            BEGIN
                RAISERROR('Không tìm thấy lớp trên site chủ.', 16, 1);
            END
        END
        RETURN;
    END

    -- Kiểm tra quyền hạn của login
    SELECT @UserRole = 
        CASE 
            WHEN USER_NAME() = 'KHOA' THEN 'KHOA'
            WHEN USER_NAME() = 'SV' THEN 'SV'
            WHEN USER_NAME() = 'PGV' THEN 'PGV'
            ELSE 'Unknown'
        END;

    -- Kiểm tra quyền và thực hiện truy vấn tương ứng
    IF @UserRole = 'KHOA' OR @UserRole = 'SV'
    BEGIN
        -- Truy vấn danh sách sinh viên trong khoa và lớp hiện tại
        SELECT sv.MASV, sv.HO, sv.TEN, sv.PHAI, sv.DIACHI, sv.NGAYSINH
        FROM SINHVIEN sv
        JOIN LOP l ON sv.MALOP = l.MALOP
        WHERE l.MAKHOA = @MAKHOA AND l.MALOP = @MALOP;
    END
    ELSE IF @UserRole = 'PGV'
    BEGIN
        -- Truy vấn danh sách sinh viên từ site chủ nếu là PGV
        IF EXISTS (SELECT MALOP FROM LINK0.QLSVTC.dbo.LOP WHERE MALOP = @MALOP)
        BEGIN
            SELECT sv.MASV, sv.HO, sv.TEN, sv.PHAI, sv.DIACHI, sv.NGAYSINH
            FROM LINK0.QLSVTC.dbo.SINHVIEN sv
            JOIN LINK0.QLSVTC.dbo.LOP l ON sv.MALOP = l.MALOP
            WHERE l.MALOP = @MALOP;
        END
        ELSE
        BEGIN
            RAISERROR('Không tìm thấy lớp trên site chủ.', 16, 1);
        END
    END
    ELSE
    BEGIN
        RAISERROR('Quyền hạn không hợp lệ.', 16, 1);
    END
END;

GO

