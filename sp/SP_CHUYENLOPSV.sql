USE [QLSVTC]
GO
/****** Object:  StoredProcedure [dbo].[SP_CHUYENLOP_N2]    Script Date: 11/21/2024 1:05:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Mục đích: chuyển sinh viên từ chi lớp này sang lớp khác, dk sinh chưa có điểm thành phần nào */

/* Trong sp này sử dụng transaction mức Serializable -  mức an toàn - TT2 đang đọc một bảng dữ liệu thì TT1 không thể chỉnh sửa
 bảng dữ liệu này cho đến khi TT2 hoàn tất việc đọc dữ liệu đó. Nói nôm na là dữ liệu đang được đọc sẽ được bảo vệ khỏi cập nhật bởi các transaction khác */

ALTER PROC [dbo].[SP_CHUYENLOP]
	@MASV NCHAR(10), 
	@MALOP NCHAR(10)
AS
-- Định nghĩa biến
DECLARE @MACN NCHAR(10);
SET XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN
	-- Điều kiện dùng loại transaction
	DECLARE @IsDistributed BIT = 0;
	DECLARE @HO NVARCHAR(50)
	DECLARE @TEN NVARCHAR(10)
	DECLARE @PHAI BIT
	DECLARE @DIACHI NVARCHAR(100)
	DECLARE @NGAYSINH DATE
	DECLARE @MASV_TEMP NCHAR(10)
	-- Kiểm tra có điểm thành phần hay chưa
	IF NOT EXISTS (SELECT 1 FROM dbo.SINHVIEN WHERE MASV = @MASV AND DANGHIHOC=0)
	BEGIN
			RAISERROR( 'Không tìm thấy hoặc sinh viên đã nghỉ học.', 16, 1);
			ROLLBACK TRANSACTION; -- Nếu không tìm thấy sinh viên, rollback giao dịch
			RETURN;
	END
	IF EXISTS (SELECT 1 FROM dbo.DANGKY WHERE MASV = @MASV 
                 AND (DIEM_CC IS NOT NULL OR DIEM_GK IS NOT NULL OR DIEM_CK IS NOT NULL))
		BEGIN
			RAISERROR( 'Sinh viên đã có điểm, không thể chuyển lớp.', 16, 1);
			RETURN;
		END
	-- Lưu thông tin SV để đối chiếu
	SELECT @HO = HO, @TEN = TEN, @DIACHI = DIACHI, @PHAI = PHAI, @NGAYSINH = NGAYSINH FROM SINHVIEN WHERE MASV = @MASV

	IF NOT EXISTS (SELECT MALOP FROM LOP WHERE MALOP = @MALOP)
		SET @IsDistributed = 1;

	BEGIN TRY
	IF @IsDistributed = 0

	BEGIN
		BEGIN TRANSACTION;	-- Bắt đầu giao tác toàn cục
		-- Kiểm tra ở site hiện tại
		IF EXISTS(SELECT MASV 
				FROM SINHVIEN 
				WHERE HO = @HO AND TEN = @TEN AND DIACHI = @DIACHI 
				AND PHAI = @PHAI AND NGAYSINH = @NGAYSINH AND MALOP = @MALOP)
		BEGIN 
				-- PRINT 'sinh viên đã từng trong lớp ' + @MALOP +' với mã ' + @MASV_TEMP;
				UPDATE SINHVIEN
				SET DANGHIHOC = 0
				WHERE MASV = (SELECT MASV 
					FROM SINHVIEN 
					WHERE HO = @HO AND TEN = @TEN AND DIACHI = @DIACHI 
					AND PHAI = @PHAI AND NGAYSINH = @NGAYSINH AND MALOP=@MALOP)
		END
		ELSE
		-- Nếu chưa tồn tại thì thêm mới hoàn toàn vào lớp mới với MASV sẽ là MASV = MAX(MASV)+1
		BEGIN	
		-- Lây thông tin MASV, MACN của lớp chuyển tới làm mẫu, để thêm mới
				--SELECT TOP 1 @MASV_TEMP=MASV,  @MACN=MACN FROM SINHVIEN WHERE MALOP=@MALOP ORDER BY MASV DESC;
				SELECT TOP 1 @MACN = MACN FROM SINHVIEN WHERE MALOP=@MALOP;
				SELECT TOP 1 @MASV_TEMP=MASV FROM SINHVIEN WHERE MACN=@MACN AND LEFT(MASV, 3) = LEFT(@MASV, 3) ORDER BY MASV DESC;
				INSERT INTO SINHVIEN (MASV, HO, TEN, PHAI, DIACHI, NGAYSINH, MALOP, MACN)
				VALUES (  -- Tạo MANV mới bằng cách lấy phần số cuối, cộng thêm 1 và đệm 0
    LEFT(@MASV_TEMP, LEN(@MASV_TEMP) - 3) + RIGHT('000' + CAST(CAST(SUBSTRING(@MASV_TEMP, LEN(@MASV_TEMP) - 2, 3) AS INT) + 1 AS VARCHAR), 3),
				@HO, @TEN, @PHAI, @DIACHI, @NGAYSINH, @MALOP, @MACN)
		END
	END
	ELSE
	-- Bắt đầu giao tác phân tán
	BEGIN
	BEGIN DISTRIBUTED TRANSACTION;	-- Bắt đầu giao tác toàn cục
	-- Kiểm tra site VT
	IF EXISTS(SELECT MASV 
				FROM LINK1.QLSVTC.dbo.SINHVIEN 
				WHERE HO = @HO AND TEN = @TEN AND DIACHI = @DIACHI 
				AND PHAI = @PHAI AND NGAYSINH = @NGAYSINH AND MALOP = @MALOP)
		BEGIN 
				-- PRINT 'sinh viên đã từng trong lớp ' + @MALOP +' với mã ' + @MASV_TEMP;
				UPDATE SINHVIEN
				SET DANGHIHOC = 0
				WHERE MASV = (SELECT MASV 
					FROM LINK1.QLSVTC.dbo.SINHVIEN 
					WHERE HO = @HO AND TEN = @TEN AND DIACHI = @DIACHI 
					AND PHAI = @PHAI AND NGAYSINH = @NGAYSINH AND MALOP=@MALOP)
		END
		ELSE
		-- Nếu chưa tồn tại thì thêm mới hoàn toàn vào lớp mới với MASV sẽ là MASV = MAX(MASV)+1
		BEGIN	
		-- Lây thông tin MASV, MACN của lớp chuyển tới làm mẫu, để thêm mới
				--SELECT TOP 1 @MASV_TEMP=MASV,  @MACN=MACN FROM LINK1.QLSVTC.dbo.SINHVIEN WHERE MALOP=@MALOP ORDER BY MASV DESC;
				SELECT TOP 1 @MACN = MACN FROM LINK1.QLSVTC.dbo.SINHVIEN WHERE MALOP=@MALOP;
				SELECT TOP 1 @MASV_TEMP=MASV FROM LINK1.QLSVTC.dbo.SINHVIEN WHERE MACN=@MACN AND LEFT(MASV, 3) = LEFT(@MASV, 3) ORDER BY MASV DESC;
				INSERT INTO LINK1.QLSVTC.dbo.SINHVIEN (MASV, HO, TEN, PHAI, DIACHI, NGAYSINH, MALOP, MACN)
				VALUES (  -- Tạo MANV mới bằng cách lấy phần số cuối, cộng thêm 1 và đệm 0
    LEFT(@MASV_TEMP, LEN(@MASV_TEMP) - 3) + RIGHT('000' + CAST(CAST(SUBSTRING(@MASV_TEMP, LEN(@MASV_TEMP) - 2, 3) AS INT) + 1 AS VARCHAR), 3),
				@HO, @TEN, @PHAI, @DIACHI, @NGAYSINH, @MALOP, @MACN)
		END
	END
		-- Đổi trạng thái xóa đối với SV ở site hiện tại
		UPDATE dbo.SINHVIEN
		SET DANGHIHOC = 1
		WHERE MASV = @MASV

		COMMIT TRANSACTION; -- Kết thúc giao tác
		SELECT 'Chuyển lớp cho sinh viên thành công.' AS MESSAGE;
	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION; -- Hủy giao tác nếu có lỗi
		PRINT 'Chuyển lớp cho sinh viên được hủy do lỗi.';
		-- Trả về chi tiết của lỗi
		SELECT
			ERROR_MESSAGE() AS ErrorMessage,
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_LINE() AS ErrorLine;
    END CATCH;
END
	
