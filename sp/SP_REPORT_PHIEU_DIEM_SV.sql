USE [QLSVTC]
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_PHIEU_DIEM_SV]    Script Date: 12/2/2024 10:19:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORT_PHIEU_DIEM_SV]
    @MASV NCHAR(10) -- Mã sinh viên
AS
BEGIN
    -- Tạo danh sách phiếu điểm
    SELECT 
        -- ROW_NUMBER() OVER (ORDER BY MONHOC.TENMONHOC) AS STT, -- Số thứ tự
        MONHOC.TENMONHOC,                                    -- Tên môn học
        -- Tính điểm hết môn = Điểm_CC * 0.1 + Điểm_GK * 0.3 + Điểm_CK * 0.6
        MAX(FilteredDANGKY.DIEM_CC * 0.1 + 
        FilteredDANGKY.DIEM_GK * 0.3 + 
        FilteredDANGKY.DIEM_CK * 0.6) AS DIEM_HET_MON -- Điểm hết môn
    FROM 
        (SELECT MALTC, DIEM_CC, DIEM_GK, DIEM_CK FROM DANGKY WHERE MASV = @MASV AND HUYDANGKY=0) AS FilteredDANGKY          
    INNER JOIN 
        LOPTINCHI ON FilteredDANGKY.MALTC = LOPTINCHI.MALTC         -- Liên kết lớp tín chỉ
    INNER JOIN 
        MONHOC ON LOPTINCHI.MAMH = MONHOC.MAMH              -- Liên kết môn học
	GROUP BY
		MONHOC.TENMONHOC
    ORDER BY 
        MONHOC.TENMONHOC;                                   -- Sắp xếp theo tên môn học
END

