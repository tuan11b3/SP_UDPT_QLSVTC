USE [QLSVTC]
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_DS_LOPTINCHI]    Script Date: 11/21/2024 1:07:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORT_DS_LOPTINCHI]
    @NIENKHOA INT,      -- Niên khóa
    @HOCKY INT          -- Học kỳ
AS
BEGIN
    DECLARE @MANKHK INT
    SELECT @MANKHK = MANKHK FROM NKHK WHERE NAMHOC = @NIENKHOA AND HK = @HOCKY 

    SELECT 
        MONHOC.TENMONHOC AS TENMH,                  -- Tên môn học
        FilteredLOPTINCHI.NHOM,                    -- Nhóm
        GIANGVIEN.HO + ' ' + GIANGVIEN.TEN AS GV,  -- Họ và tên giảng viên
        FilteredLOPTINCHI.SOSVTOITHIEU,            -- Số sinh viên tối thiểu
        COUNT(DANGKY.MASV) AS SOSVDANGKY           -- Số sinh viên đăng ký
    FROM 
        (SELECT * 
         FROM LOPTINCHI 
         WHERE MANKHK = @MANKHK AND HUYLOP = 0) AS FilteredLOPTINCHI
    INNER JOIN 
        MONHOC ON FilteredLOPTINCHI.MAMH = MONHOC.MAMH
    INNER JOIN 
        GIANGDAY ON FilteredLOPTINCHI.MALTC = GIANGDAY.MALTC
    INNER JOIN 
        GIANGVIEN ON GIANGDAY.MAGV = GIANGVIEN.MAGV
    LEFT JOIN 
        DANGKY ON FilteredLOPTINCHI.MALTC = DANGKY.MALTC
    GROUP BY 
        MONHOC.TENMONHOC,
        FilteredLOPTINCHI.NHOM,
        GIANGVIEN.HO,
        GIANGVIEN.TEN,
        FilteredLOPTINCHI.SOSVTOITHIEU
    ORDER BY 
        MONHOC.TENMONHOC, 
        FilteredLOPTINCHI.NHOM;
END
