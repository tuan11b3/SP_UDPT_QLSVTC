USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_REPORT_PHIEU_DIEM_SV]    Script Date: 11/16/2024 3:15:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REPORT_PHIEU_DIEM_SV]
    @MaSV NCHAR(10) -- Mã sinh viên
AS
BEGIN
    -- Tạo danh sách phiếu điểm
    SELECT 
        ROW_NUMBER() OVER (ORDER BY MONHOC.TENMONHOC) AS STT, -- Số thứ tự
        MONHOC.TENMONHOC,                                    -- Tên môn học
        -- Tính điểm hết môn = Điểm_CC * 0.1 + Điểm_GK * 0.3 + Điểm_CK * 0.6
        (COALESCE(DANGKY.DIEM_CC, 0) * 0.1 + 
         COALESCE(DANGKY.DIEM_GK, 0) * 0.3 + 
         COALESCE(DANGKY.DIEM_CK, 0) * 0.6) AS DIEM_HET_MON -- Điểm hết môn
    FROM 
        SINHVIEN
    INNER JOIN 
        DANGKY ON SINHVIEN.MASV = DANGKY.MASV               -- Liên kết sinh viên với đăng ký
    INNER JOIN 
        LOPTINCHI ON DANGKY.MALTC = LOPTINCHI.MALTC         -- Liên kết lớp tín chỉ
    INNER JOIN 
        MONHOC ON LOPTINCHI.MAMH = MONHOC.MAMH              -- Liên kết môn học
    WHERE 
        SINHVIEN.MASV = @MaSV                               -- Chỉ lọc theo sinh viên được chọn
    ORDER BY 
        MONHOC.TENMONHOC;                                   -- Sắp xếp theo tên môn học
END

GO

