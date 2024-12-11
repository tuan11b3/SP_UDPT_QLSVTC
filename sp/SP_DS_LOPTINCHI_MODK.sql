USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_DS_LOPTINCHI_MODK]    Script Date: 12/11/2024 7:54:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DS_LOPTINCHI_MODK]
AS
DECLARE @ngayht DATE = CAST(GETDATE() AS DATE)
DECLARE @ngaymodk DATE
DECLARE @ngaydodk DATE
DECLARE @mankhk INT = NULL;
SET XACT_ABORT ON;
BEGIN
	SELECT @mankhk=MANKHK FROM NKHK WHERE NGAYMODK <= @ngayht AND @ngayht < NGAYDONGDK;
	IF @mankhk IS NULL
	BEGIN
		RAISERROR(N'Ngoài thời gian đăng ký!', 16, 1)
		RETURN
	END
	SELECT  FilteredLTC.MALTC,
			mh.MAMH,
			mh.TENMONHOC,
			FilteredLTC.NHOM,
			GV = STUFF(								-- Họ và tên giảng viên
			(SELECT ', ' + gv.HO + ' ' + gv.TEN 
			 FROM GIANGVIEN gv 
			 INNER JOIN GIANGDAY gd ON gv.MAGV = gd.MAGV
			 WHERE gd.MALTC = FilteredLTC.MALTC
			 FOR XML PATH('')), 1, 1, ''), 
			COUNT(dk.MASV) AS sosvdk
	FROM (SELECT MALTC, NHOM, MAMH FROM LOPTINCHI WHERE MANKHK = @mankhk AND HUYLOP = 0) AS FilteredLTC
	INNER JOIN MONHOC mh ON FilteredLTC.MAMH = mh.MAMH
	LEFT JOIN DANGKY dk ON FilteredLTC.MALTC = dk.MALTC AND dk.HUYDANGKY=0
	GROUP BY  FilteredLTC.MALTC,
			  FilteredLTC.NHOM,
			  mh.TENMONHOC,
			  mh.MAMH 
	ORDER BY  mh.TENMONHOC,
			  FilteredLTC.NHOM;
END
GO

