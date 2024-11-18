USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_CHUYENLOP]    Script Date: 11/18/2024 1:49:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_CHUYENLOP]
@MASV NCHAR(10), @MALOP NCHAR(10)
AS
BEGIN
	-- Định nghĩa biến
	DECLARE @MACN NCHAR(10);

	SET XACT_ABORT ON;
	BEGIN TRY
	BEGIN TRANSACTION; -- bắt đầu giao tác phân tán
	
	IF NOT EXISTS(SELECT MASV FROM dbo.SINHVIEN WHERE MASV=@MASV)
	BEGIN
		RAISERROR( 'Không tìm thấy mã sinh viên.', 16, 1);
		RETURN;
	END
		IF NOT EXISTS(SELECT MALOP FROM dbo.LOP WHERE MALOP=@MALOP)
		BEGIN
			IF NOT EXISTS(SELECT MALOP FROM LINK0.QLSVTC.dbo.LOP WHERE MALOP=@MALOP)
			BEGIN
				RAISERROR( 'Không tìm thấy mã lớp tương ứng.', 16, 1);
				RETURN;
			END
		END
		IF EXISTS (SELECT 1 FROM dbo.DANGKY WHERE MASV = @MASV 
                 AND (DIEM_CC IS NOT NULL OR DIEM_GK IS NOT NULL OR DIEM_CK IS NOT NULL))
		BEGIN
			RAISERROR( 'Sinh viên đã có điểm, không thể chuyển lớp.', 16, 1);
			RETURN;
		END
		
		/*
			-- Update MALOP cho sinh vien
			UPDATE dbo.SINHVIEN SET MALOP=@MALOP WHERE MASV=@MASV;	*/

			-- Select 1 chuyên ngành theo sinh vien thuộc lớp cần chuyển
			SELECT TOP 1 @MACN = MACN FROM SINHVIEN WHERE MALOP=@MALOP;

			-- Update MACN cho sinh vien
			UPDATE dbo.SINHVIEN SET MALOP=@MALOP, MACN=@MACN WHERE MASV=@MASV;

			-- Commit giao tác phân tán thành công
			COMMIT TRANSACTION;

			-- Trả về message thành công
			SELECT 'Chuyển lớp cho sinh viên thành công hành công.' AS MESSAGE;
				
		END TRY
		BEGIN CATCH
			-- Rollback nếu xảy ra lỗi
			ROLLBACK TRANSACTION;
			PRINT 'Chuyển lớp cho sinh viên được hủy do lỗi.';

			-- Trả về chi tiết của lỗi
			SELECT
				ERROR_MESSAGE() AS ErrorMessage,
				ERROR_NUMBER() AS ErrorNumber,
				ERROR_LINE() AS ErrorLine;
		END CATCH;

END
GO

