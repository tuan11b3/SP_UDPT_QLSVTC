USE [QLSVTC]
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_BANG_DIEM_LTC]    Script Date: 11/21/2024 1:06:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORT_BANG_DIEM_LTC]
    @NIENKHOA INT,          -- Niên khóa
    @HOCKY INT,             -- Học kỳ
    @MAMH NCHAR(10),        -- Mã môn học
    @NHOM INT               -- Nhóm lớp tín chỉ
AS
BEGIN
	DECLARE @MANKHK INT, @MALTC INT
	SELECT @MANKHK = MANKHK FROM NKHK WHERE NAMHOC = @NIENKHOA AND HK = @HOCKY 
	SELECT @MALTC = MALTC FROM LOPTINCHI WHERE MANKHK = @MANKHK AND MAMH=@MAMH AND NHOM=@NHOM
    -- Truy vấn bảng điểm
    SELECT 
        SV.MASV,                                         -- Mã sinh viên
        SV.HO,                                           -- Họ
        SV.TEN,                                          -- Tên
        DK.DIEM_CC,                                        -- Điểm chuyên cần
        DK.DIEM_GK,                                        -- Điểm giữa kỳ
        DK.DIEM_CK,                                        -- Điểm cuối kỳ
        CAST(
            DK.DIEM_CC * 0.1 + DK.DIEM_GK * 0.3 + DK.DIEM_CK * 0.6 
            AS DECIMAL(5, 2)
        ) AS DIEM_HET_MON                                      -- Điểm hết môn
    FROM 
        dbo.SINHVIEN AS SV,
		dbo.DANGKY AS DK
    WHERE 
        DK.MALTC = @MALTC 
		AND SV.MASV = DK.MASV                 
    ORDER BY 
        SV.TEN, SV.HO;                           -- Sắp xếp theo tên và họ tăng dần
END

