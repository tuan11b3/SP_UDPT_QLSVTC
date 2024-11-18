USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_CHUYENLOPSV]    Script Date: 11/16/2024 3:12:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CHUYENLOPSV] 
    @MASV_ARRAY NVARCHAR(MAX),  -- Mảng MASV, dưới dạng chuỗi JSON
    @MALOP NVARCHAR(10)  -- Mã lớp cần chuyển đến
AS
BEGIN
    DECLARE @TransactionStatus BIT = 1;  -- Biến theo dõi trạng thái giao tác
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Chuyển JSON thành bảng tạm sử dụng phương pháp XML với loại bỏ khoảng trắng
        DECLARE @StudentList TABLE (MASV nvarchar(10));

        ;WITH MASV_XML AS (
            SELECT CAST('<root><value>' + REPLACE(REPLACE(@MASV_ARRAY, ' ', ''), ',', '</value><value>') + '</value></root>' AS XML) AS MASV_XML
        )
        INSERT INTO @StudentList (MASV)
        SELECT
            LTRIM(RTRIM(MASV.value('.', 'nvarchar(10)')))
        FROM MASV_XML
        CROSS APPLY MASV_XML.MASV_XML.nodes('/root/value') AS MASV(MASV);

        -- Kiểm tra nếu lớp mới tồn tại
        IF NOT EXISTS (SELECT 1 FROM LOP WHERE LTRIM(RTRIM(MALOP)) = @MALOP)
        BEGIN
            RAISERROR (N'Mã lớp %s không tồn tại trên site hiện tại', 16, 1, @MALOP);
            SET @TransactionStatus = 0;  -- Cập nhật trạng thái thất bại
        END
        ELSE
        BEGIN
            -- Lấy tên lớp
            DECLARE @TENLOP nvarchar(50);
            SELECT @TENLOP = TENLOP FROM LOP WHERE MALOP = @MALOP;

            -- Khai báo biến con trỏ cho MASV
            DECLARE @Current_MASV nvarchar(10);  -- Khai báo biến trước khi sử dụng

            -- Cập nhật lớp cho từng sinh viên
            DECLARE cur CURSOR FOR
                SELECT MASV FROM @StudentList;

            OPEN cur;
            FETCH NEXT FROM cur INTO @Current_MASV;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                -- Kiểm tra nếu sinh viên có mặt trong hệ thống
                IF EXISTS (SELECT 1 FROM SINHVIEN WHERE MASV = @Current_MASV)
                BEGIN
                    -- Kiểm tra nếu sinh viên chưa có điểm
                    IF NOT EXISTS (SELECT 1 FROM DANGKY WHERE MASV = @Current_MASV 
                                   AND (DIEM_CC IS NOT NULL OR DIEM_GK IS NOT NULL OR DIEM_CK IS NOT NULL))
                    BEGIN
                        -- Cập nhật lớp cho sinh viên
                        UPDATE SINHVIEN SET MALOP = @MALOP WHERE MASV = @Current_MASV;
                        PRINT N'Cập nhật thành công: Sinh viên ' + @Current_MASV + ' đã chuyên sang lớp ' + @TENLOP;
                    END
                    ELSE
                    BEGIN
                        PRINT N'Không thể chuyển lớp: Sinh viên ' + @Current_MASV + ' có diem đã nhâp cho các lơp tín chỉ';
                    END
                END
                ELSE
                BEGIN
                    -- Mã sinh viên không tồn tại
                    PRINT N'Mã sinh viên ' + @Current_MASV + ' không tồn tại trên site hiện tại';
                    -- Không rollback giao dịch, chỉ bỏ qua sinh viên này
                END

                -- Cập nhật con trỏ
                FETCH NEXT FROM cur INTO @Current_MASV;
            END

            CLOSE cur;
            DEALLOCATE cur;
        END

        -- Xác nhận giao dịch thành công nếu không có lỗi
        IF @TransactionStatus = 1
        BEGIN
            COMMIT TRANSACTION;
            PRINT N'Tất cả các sinh viên đã được chuyển lớp thành công';
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT N'Giao dịch thất bại. Một số sinh viên không thể chuyển lớp';
        END
    END TRY
    BEGIN CATCH
        -- ROLLBACK nếu có lỗi và tái ném lỗi
        ROLLBACK TRANSACTION;
        SET @TransactionStatus = 0;
        PRINT N'Đã xảy ra lỗi, giao dịch bị hủy bỏ.';
        THROW;  -- Tái ném lỗi để hiển thị trong tab Messages
    END CATCH;

    RETURN @TransactionStatus;
END;
GO

