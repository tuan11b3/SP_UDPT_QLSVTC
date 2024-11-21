USE [QLSVTC]
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_DIEMTONGKET]    Script Date: 11/21/2024 1:06:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORT_DIEMTONGKET]
  @MALOP NCHAR(10)
AS
BEGIN
  DECLARE @MASV NVARCHAR(10), @HO NVARCHAR(50), @TEN NVARCHAR(50), @MALTC INT, @DIEM_TONGKET NUMERIC(5, 2)
  -- Kiểm tra xem có lớp trong cơ sở dữ liệu chính
  IF EXISTS (SELECT MALOP FROM LOP WHERE MALOP = @MALOP)
  BEGIN
    -- Tính điểm tổng kết cho sinh viên trong cơ sở dữ liệu chính
    SELECT 
      sv.MASV, 
      sv.HO, 
      sv.TEN,
      dk.MALTC,
      -- Tính điểm tổng kết
      MAX(dk.DIEM_CC * 0.1 + dk.DIEM_GK * 0.3 + dk.DIEM_CK * 0.6) AS DIEM_TONGKET,
      mh.TENMONHOC
    INTO #BangDiem
    FROM (SELECT MASV, HO, TEN FROM SINHVIEN WHERE MALOP = @MALOP) AS sv
    JOIN DANGKY dk ON sv.MASV = dk.MASV
    JOIN LOPTINCHI ltc ON dk.MALTC = ltc.MALTC
    JOIN MONHOC mh ON ltc.MAMH = mh.MAMH
    GROUP BY sv.MASV, sv.HO, sv.TEN, dk.MALTC, mh.TENMONHOC

    -- Tạo câu lệnh SQL động để Pivot dữ liệu
    DECLARE @SQL2 NVARCHAR(MAX), @TenMonHocList NVARCHAR(MAX)

    -- Tạo danh sách tên môn học từ bảng #BangDiem (là ds môn học mà các sv trong lớp từng đk)
    SELECT @TenMonHocList = STUFF((SELECT ',' + QUOTENAME(TENMONHOC)
                                    FROM #BangDiem
                                    GROUP BY TENMONHOC
                                    ORDER BY TENMONHOC
                                    FOR XML PATH('')), 1, 1, '')

    -- Tạo câu lệnh SQL động với PIVOT
    SET @SQL2 = '
      SELECT 
        MASV, HO, TEN, 
        ' + @TenMonHocList + ' 
      FROM 
        (SELECT MASV, HO, TEN, TENMONHOC, DIEM_TONGKET 
         FROM #BangDiem) AS SourceTable
      PIVOT
        (MAX(DIEM_TONGKET) FOR TENMONHOC IN (' + @TenMonHocList + ')) AS PivotTable
      ORDER BY MASV
    '

    -- Thực thi câu lệnh SQL động
    EXEC sp_executesql @SQL2

    -- Xóa bảng tạm
    DROP TABLE #BangDiem
  
  END
  ELSE
    -- Nếu không tìm thấy lớp trong cả hai cơ sở dữ liệu, báo lỗi
    RAISERROR (N'Lớp học không tồn tại trong hệ thống', 16, 1)
END

