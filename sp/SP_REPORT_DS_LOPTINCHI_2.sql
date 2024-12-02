USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_REPORT_DS_LOPTINCHI_2]    Script Date: 12/2/2024 10:17:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REPORT_DS_LOPTINCHI_2]
    @NIENKHOA INT,      -- Niên khóa
    @HOCKY INT          -- Học kỳ
AS
BEGIN
    DECLARE @MANKHK INT = NULL;
    SELECT @MANKHK = MANKHK FROM NKHK WHERE NAMHOC = @NIENKHOA AND HK = @HOCKY 
	IF @MANKHK IS NULL
	BEGIN
		RAISERROR(N'Niên khóa học kỳ không tồn tại!', 16, 1)
		RETURN
	END

    SELECT 
    mh.TENMONHOC AS TENMH,                  -- Tên môn học
    FilteredLOPTINCHI.NHOM,                 -- Nhóm
    GV = STUFF(								-- Họ và tên giảng viên
        (SELECT ', ' + gv.HO + ' ' + gv.TEN 
         FROM GIANGVIEN gv 
         INNER JOIN GIANGDAY gd ON gv.MAGV = gd.MAGV
         WHERE gd.MALTC = FilteredLOPTINCHI.MALTC
         FOR XML PATH('')), 1, 1, ''),      
    FilteredLOPTINCHI.SOSVTOITHIEU,         -- Số sinh viên tối thiểu
    COUNT(dk.MASV) AS SOSVDANGKY            -- Số sinh viên đăng ký
	FROM 
		(SELECT MALTC, NHOM, MAMH, SOSVTOITHIEU 
		 FROM LOPTINCHI 
		 WHERE MANKHK = @MANKHK AND HUYLOP = 0) AS FilteredLOPTINCHI
	INNER JOIN 
		MONHOC mh ON FilteredLOPTINCHI.MAMH = mh.MAMH
	LEFT JOIN 
		DANGKY dk ON FilteredLOPTINCHI.MALTC = dk.MALTC AND dk.HUYDANGKY=0
	GROUP BY 
		mh.TENMONHOC,
		FilteredLOPTINCHI.NHOM,
		FilteredLOPTINCHI.SOSVTOITHIEU,  
		FilteredLOPTINCHI.MALTC                -- Thêm vào để hỗ trợ cho STUFF
	ORDER BY 
		mh.TENMONHOC, 
		FilteredLOPTINCHI.NHOM;
END

GO

