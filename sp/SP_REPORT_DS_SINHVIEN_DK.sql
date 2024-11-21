USE [QLSVTC]
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_DS_SINHVIEN_DANGKY]    Script Date: 11/21/2024 1:07:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORT_DS_SINHVIEN_DANGKY]
    @NIENKHOA INT,         -- Niên khóa
    @HOCKY INT,            -- Học kỳ
    @MAMH NCHAR(10),       -- Mã môn học
    @NHOM INT              -- Nhóm lớp tín chỉ
AS
BEGIN
	DECLARE @MALTC INT, @MANKHK INT
	SELECT @MANKHK = MANKHK FROM NKHK WHERE NAMHOC = @NIENKHOA AND HK = @HOCKY
	SELECT @MALTC = MALTC FROM LOPTINCHI WHERE MANKHK = @MANKHK AND MAMH = @MAMH AND NHOM = @NHOM
    -- Kết quả trả về danh sách sinh viên đăng ký lớp tín chỉ
    SELECT 
        SV.MASV,                    -- Mã sinh viên
        SV.HO,                      -- Họ sinh viên
        SV.TEN,                     -- Tên sinh viên
        CASE WHEN SV.PHAI = 1 THEN N'Nam' ELSE N'Nữ' END AS PHAI, -- Phái
        SV.MALOP                    -- Mã lớp
    FROM 
        SINHVIEN AS SV,
		DANGKY AS DK
    WHERE 
        DK.MALTC = @MALTC 
		AND SV.MASV = DK.MASV                         
    ORDER BY 
        SV.TEN, SV.HO;         -- Sắp xếp theo tên và họ tăng dần
END

