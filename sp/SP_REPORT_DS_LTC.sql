USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_REPORT_DS_LOPTINCHI]    Script Date: 11/16/2024 3:14:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REPORT_DS_LOPTINCHI]
    @NienKhoa INT,      -- Niên khóa
    @HocKy INT          -- Học kỳ
AS
BEGIN
    -- Kết quả trả về thông tin chi tiết về lớp tín chỉ
    SELECT 
        MONHOC.TENMONHOC AS TENMH,                  -- Tên môn học
        LOPTINCHI.NHOM,                            -- Nhóm
        GIANGVIEN.HO + ' ' + GIANGVIEN.TEN AS GV,  -- Họ và tên giảng viên
        LOPTINCHI.SOSVTOITHIEU,                    -- Số sinh viên tối thiểu
        COUNT(DANGKY.MASV) AS SOSVDANGKY           -- Số sinh viên đăng ký
    FROM 
        LOPTINCHI
    INNER JOIN 
        MONHOC ON LOPTINCHI.MAMH = MONHOC.MAMH
    INNER JOIN 
        GIANGDAY ON LOPTINCHI.MALTC = GIANGDAY.MALTC
    INNER JOIN 
        GIANGVIEN ON GIANGDAY.MAGV = GIANGVIEN.MAGV
    INNER JOIN 
        NKHK ON LOPTINCHI.MANKHK = NKHK.MANKHK
    LEFT JOIN 
        DANGKY ON LOPTINCHI.MALTC = DANGKY.MALTC
    WHERE 
        NKHK.NAMHOC = @NienKhoa
        AND NKHK.HK = @HocKy
        AND LOPTINCHI.MAKHOA = 'CNTT'  -- Dữ liệu chỉ của khoa CNTT
        AND LOPTINCHI.HUYLOP = 0       -- Lớp chưa bị hủy
    GROUP BY 
        MONHOC.TENMONHOC,
        LOPTINCHI.NHOM,
        GIANGVIEN.HO,
        GIANGVIEN.TEN,
        LOPTINCHI.SOSVTOITHIEU
    ORDER BY 
        MONHOC.TENMONHOC, 
        LOPTINCHI.NHOM;
END

GO

