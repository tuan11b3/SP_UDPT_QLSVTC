USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_REPORT_DIEMTONGKET]    Script Date: 11/16/2024 3:13:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_REPORT_DIEMTONGKET]
  @MALOP NCHAR(10)
AS
BEGIN
  DECLARE @MASV NVARCHAR(10), @HO NVARCHAR(50), @TEN NVARCHAR(50), @MALTC INT, @DIEM_TONGKET NUMERIC(5, 2)

  -- Kiểm tra nếu bảng tạm #BangDiem2 đã tồn tại, xóa nó
  IF OBJECT_ID('tempdb..#BangDiem2', 'U') IS NOT NULL
  BEGIN
    DROP TABLE #BangDiem2
  END

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
    INTO #BangDiem2
    FROM SINHVIEN sv
    JOIN DANGKY dk ON sv.MASV = dk.MASV
    JOIN LOPTINCHI ltc ON dk.MALTC = ltc.MALTC
    JOIN MONHOC mh ON ltc.MAMH = mh.MAMH
    WHERE sv.MALOP = @MALOP
    GROUP BY sv.MASV, sv.HO, sv.TEN, dk.MALTC, mh.TENMONHOC

    -- Tạo câu lệnh SQL động để Pivot dữ liệu
    DECLARE @SQL2 NVARCHAR(MAX), @TenMonHocList2 NVARCHAR(MAX)

    -- Tạo danh sách tên môn học từ bảng #BangDiem
    SELECT @TenMonHocList2 = STUFF((SELECT ',' + QUOTENAME(TENMONHOC)
                                    FROM #BangDiem2
                                    GROUP BY TENMONHOC
                                    ORDER BY TENMONHOC
                                    FOR XML PATH('')), 1, 1, '')

    -- Tạo câu lệnh SQL động với PIVOT
    SET @SQL2 = '
      SELECT 
        MASV, HO, TEN, 
        ' + @TenMonHocList2 + ' 
      FROM 
        (SELECT MASV, HO, TEN, TENMONHOC, DIEM_TONGKET 
         FROM #BangDiem2) AS SourceTable
      PIVOT
        (MAX(DIEM_TONGKET) FOR TENMONHOC IN (' + @TenMonHocList2 + ')) AS PivotTable
      ORDER BY MASV
    '

    -- Thực thi câu lệnh SQL động
    EXEC sp_executesql @SQL2

    -- Xóa bảng tạm
    DROP TABLE #BangDiem2
  END
  ELSE
  -- Kiểm tra nếu dữ liệu ở cơ sở dữ liệu liên kết (ví dụ, LINK0.TRACNGHIEM)
  IF EXISTS (SELECT MALOP FROM LINK0.QLSVTC.dbo.LOP WHERE MALOP = @MALOP)
  BEGIN
    -- Tính điểm tổng kết cho sinh viên trong cơ sở dữ liệu liên kết
    SELECT 
      sv.MASV, 
      sv.HO, 
      sv.TEN,
      dk.MALTC,
      -- Tính điểm tổng kết
      MAX(dk.DIEM_CC * 0.1 + dk.DIEM_GK * 0.3 + dk.DIEM_CK * 0.6) AS DIEM_TONGKET,
      mh.TENMONHOC
    INTO #BangDiem
    FROM LINK0.QLSVTC.dbo.SINHVIEN sv
    JOIN LINK0.QLSVTC.dbo.DANGKY dk ON sv.MASV = dk.MASV
    JOIN LINK0.QLSVTC.dbo.LOPTINCHI ltc ON dk.MALTC = ltc.MALTC
    JOIN LINK0.QLSVTC.dbo.MONHOC mh ON ltc.MAMH = mh.MAMH
    WHERE sv.MALOP = @MALOP
    GROUP BY sv.MASV, sv.HO, sv.TEN, dk.MALTC, mh.TENMONHOC

    -- Tạo câu lệnh SQL động để Pivot dữ liệu
    DECLARE @SQL NVARCHAR(MAX), @TenMonHocList NVARCHAR(MAX)

    -- Tạo danh sách tên môn học từ bảng #BangDiem
    SELECT @TenMonHocList = STUFF((SELECT ',' + QUOTENAME(TENMONHOC)
                                    FROM #BangDiem
                                    GROUP BY TENMONHOC
                                    ORDER BY TENMONHOC
                                    FOR XML PATH('')), 1, 1, '')

    -- Tạo câu lệnh SQL động với PIVOT
    SET @SQL = '
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
    EXEC sp_executesql @SQL

    -- Xóa bảng tạm
    DROP TABLE #BangDiem
  END
  ELSE
    -- Nếu không tìm thấy lớp trong cả hai cơ sở dữ liệu, báo lỗi
    RAISERROR (N'Lớp học không tồn tại trong hệ thống', 16, 1)
END

GO

