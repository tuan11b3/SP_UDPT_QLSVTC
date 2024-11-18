USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_REPORT_DS_SINHVIEN_DANGKY]    Script Date: 11/16/2024 3:14:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REPORT_DS_SINHVIEN_DANGKY]
    @NienKhoa INT,         -- Niên khóa
    @HocKy INT,            -- Học kỳ
    @MaMH NCHAR(10),       -- Mã môn học
    @Nhom INT              -- Nhóm lớp tín chỉ
AS
BEGIN
    -- Kết quả trả về danh sách sinh viên đăng ký lớp tín chỉ
    SELECT 
        SINHVIEN.MASV,                    -- Mã sinh viên
        SINHVIEN.HO,                      -- Họ sinh viên
        SINHVIEN.TEN,                     -- Tên sinh viên
        CASE WHEN SINHVIEN.PHAI = 1 THEN N'Nam' ELSE N'Nữ' END AS PHAI, -- Phái
        SINHVIEN.MALOP                    -- Mã lớp
    FROM 
        SINHVIEN
    INNER JOIN 
        DANGKY ON SINHVIEN.MASV = DANGKY.MASV
    INNER JOIN 
        LOPTINCHI ON DANGKY.MALTC = LOPTINCHI.MALTC
    INNER JOIN 
        NKHK ON LOPTINCHI.MANKHK = NKHK.MANKHK
    WHERE 
        NKHK.NAMHOC = @NienKhoa            -- Lọc theo niên khóa
        AND NKHK.HK = @HocKy               -- Lọc theo học kỳ
        AND LOPTINCHI.MAMH = @MaMH         -- Lọc theo môn học
        AND LOPTINCHI.NHOM = @Nhom         -- Lọc theo nhóm lớp tín chỉ
        AND LOPTINCHI.HUYLOP = 0           -- Chỉ lấy lớp chưa bị hủy
    ORDER BY 
        SINHVIEN.TEN, SINHVIEN.HO;         -- Sắp xếp theo tên và họ tăng dần
END

GO

