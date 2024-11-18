USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_REPORT_BANG_DIEM_LTC]    Script Date: 11/16/2024 3:13:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REPORT_BANG_DIEM_LTC]
    @NienKhoa INT,          -- Niên khóa
    @HocKy INT,             -- Học kỳ
    @MaMH NCHAR(10),        -- Mã môn học
    @Nhom INT               -- Nhóm lớp tín chỉ
AS
BEGIN
    -- Truy vấn bảng điểm
    SELECT 
        SINHVIEN.MASV,                                         -- Mã sinh viên
        SINHVIEN.HO,                                           -- Họ
        SINHVIEN.TEN,                                          -- Tên
        DANGKY.DIEM_CC,                                        -- Điểm chuyên cần
        DANGKY.DIEM_GK,                                        -- Điểm giữa kỳ
        DANGKY.DIEM_CK,                                        -- Điểm cuối kỳ
        CAST(
            DANGKY.DIEM_CC * 0.1 + DANGKY.DIEM_GK * 0.3 + DANGKY.DIEM_CK * 0.6 
            AS DECIMAL(5, 2)
        ) AS DIEM_HET_MON                                      -- Điểm hết môn
    FROM 
        SINHVIEN
    INNER JOIN 
        DANGKY ON SINHVIEN.MASV = DANGKY.MASV                 -- Liên kết với bảng đăng ký
    INNER JOIN 
        LOPTINCHI ON DANGKY.MALTC = LOPTINCHI.MALTC           -- Liên kết với bảng lớp tín chỉ
    INNER JOIN 
        NKHK ON LOPTINCHI.MANKHK = NKHK.MANKHK                -- Liên kết với bảng niên khóa học kỳ
    WHERE 
        NKHK.NAMHOC = @NienKhoa                              -- Lọc theo niên khóa
        AND NKHK.HK = @HocKy                                 -- Lọc theo học kỳ
        AND LOPTINCHI.MAMH = @MaMH                           -- Lọc theo môn học
        AND LOPTINCHI.NHOM = @Nhom                           -- Lọc theo nhóm lớp tín chỉ
        AND LOPTINCHI.HUYLOP = 0                             -- Chỉ lấy lớp chưa hủy
    ORDER BY 
        SINHVIEN.TEN, SINHVIEN.HO;                           -- Sắp xếp theo tên và họ tăng dần
END

GO

