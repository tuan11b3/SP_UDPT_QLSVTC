USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_CHUYENLOP_N3]    Script Date: 12/2/2024 10:16:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CHUYENLOP_N3]
	@MASV NCHAR(10),
	@MALOP NCHAR(10)
AS
BEGIN
	DECLARE @MACN NCHAR(10);
	SET XACT_ABORT ON;
	IF EXISTS(SELECT 1 FROM dbo.SINHVIEN WHERE MASV=@MASV)
	BEGIN
		IF EXISTS(SELECT 1 FROM dbo.DANGKY WHERE MASV=@MASV
			AND (DIEM_CC IS NOT NULL OR DIEM_GK IS NOT NULL OR DIEM_CK IS NOT NULL))
		BEGIN
			RAISERROR ('Lỗi! sinh viên [%s] đã có điểm thành phần', 16, 1, @MASV);
			RETURN;
		END
		BEGIN TRY
			BEGIN DISTRIBUTED TRANSACTION;
			IF EXISTS(SELECT 1 FROM dbo.LOP WHERE MALOP=@MALOP)
			BEGIN
				SELECT TOP 1 @MACN=MACN FROM dbo.SINHVIEN WHERE MALOP=@MALOP
				UPDATE dbo.SINHVIEN SET MALOP=@MALOP, MACN=@MACN WHERE MASV=@MASV;
			END
			ELSE
			BEGIN
				SELECT TOP 1 @MACN=MACN FROM LINK0.QLSVTC.dbo.SINHVIEN WHERE MALOP=@MALOP
				UPDATE LINK0.QLSVTC.dbo.SINHVIEN SET MALOP=@MALOP, MACN=@MACN WHERE MASV=@MASV;
			END
			COMMIT TRANSACTION;
			PRINT N'Sinh viên chuyển lớp thành công';
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
			PRINT N'Chuyển lớp cho sinh viên được hủy do lỗi.';
			SELECT
				ERROR_MESSAGE() AS ErrorMessage,
				ERROR_NUMBER() AS ErrorNumber,
				ERROR_LINE() AS ErrorLine;
		END CATCH
	END
	ELSE
		RAISERROR ('Lỗi! sinh viên [%s] không tồn tại', 16, 1, @MASV);
END
GO

