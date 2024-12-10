USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_THEM_SV]    Script Date: 12/11/2024 5:44:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_THEM_SV]
	@MALOP NCHAR(10),
	@MACN NCHAR(10),
	@HO NVARCHAR(50),
	@TEN NVARCHAR(10),
	@PHAI BIT,
	@DIACHI NVARCHAR(100),
	@NGAYSINH DATE,
	@DANGHIHOC BIT = 0,
	@PASSWORD NVARCHAR(40) = N'12345678'
AS
DECLARE @nam NCHAR(2)
DECLARE @cn_character NCHAR(2)
DECLARE @masv_pre NCHAR(8)
DECLARE @svnum NCHAR(3)
SET XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN
	BEGIN TRY
	BEGIN DISTRIBUTED TRANSACTION; --bat dau giao tac
	IF EXISTS (SELECT 1 FROM dbo.LOP WHERE MALOP = @MALOP)
		BEGIN
			select @nam= KHOAHOC % 100 FROM LOP WHERE MALOP=@MALOP
			select @cn_character = SUBSTRING(MACN, 3, 2) FROM CHUYENNGANH WHERE MACN=@MACN
			select @masv_pre = concat('D', @nam, 'DC', @cn_character,'%')
			SELECT @svnum = RIGHT('000'+LTRIM(RTRIM(CAST(count(MASV) +1 as NCHAR(3)))), 3) FROM SINHVIEN WHERE MASV LIKE @masv_pre
			select LEFT(@masv_pre, LEN(@masv_pre) - 1) + @svnum

			INSERT INTO SINHVIEN (MASV, HO, TEN, PHAI, DIACHI, NGAYSINH, MALOP, MACN, DANGHIHOC, PASSWORD)
				VALUES (LEFT(@masv_pre, LEN(@masv_pre) - 1) + @svnum, @HO, @TEN, @PHAI, @DIACHI, @NGAYSINH, @MALOP, @MACN, @DANGHIHOC, @PASSWORD)
		END
	ELSE 
		BEGIN
			IF EXISTS (SELECT 1 FROM LINK1.QLSVTC.dbo.LOP WHERE MALOP = @MALOP)
				BEGIN
					select @nam= KHOAHOC % 100 FROM LINK1.QLSVTC.dbo.LOP WHERE MALOP=@MALOP
					select @cn_character = SUBSTRING(MACN, 3, 2) FROM LINK1.QLSVTC.dbo.CHUYENNGANH WHERE MACN=@MACN
					select @masv_pre = concat('D', @nam, 'DC', @cn_character,'%')
					SELECT @svnum = RIGHT('000'+LTRIM(RTRIM(CAST(count(MASV) +1 as NCHAR(3)))), 3) FROM LINK1.QLSVTC.dbo.SINHVIEN WHERE MASV LIKE @masv_pre
					select LEFT(@masv_pre, LEN(@masv_pre) - 1) + @svnum

					INSERT INTO LINK1.QLSVTC.dbo.SINHVIEN (MASV, HO, TEN, PHAI, DIACHI, NGAYSINH, MALOP, MACN, DANGHIHOC, PASSWORD)
						VALUES (LEFT(@masv_pre, LEN(@masv_pre) - 1) + @svnum, @HO, @TEN, @PHAI, @DIACHI, @NGAYSINH, @MALOP, @MACN, @DANGHIHOC, @PASSWORD)
				END
			ELSE
				RAISERROR(N'Lỗi không tìm thấy lớp trong hệ thông!',16,1)
		END
			-- PRINT N'Mã sinh vien được thêm '+LEFT(@masv_pre, LEN(@masv_pre) - 1) + @svnum -- Dòng in mã sinh vien đưoc thêm
			COMMIT TRANSACTION; -- Kết thúc giao tác
			SELECT N'Thêm sinh viên thành công.' AS MESSAGE;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION; -- Hủy giao tác nếu có lỗi
		PRINT N'Thêm sinh viên được hủy do lỗi.';
		-- Trả về chi tiết của lỗi
		SELECT
			ERROR_MESSAGE() AS ErrorMessage,
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_LINE() AS ErrorLine;
	END CATCH
END

GO

