USE [QLSVTC]
GO

/****** Object:  StoredProcedure [dbo].[SP_HT_DANGKY]    Script Date: 12/11/2024 5:45:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_HT_DANGKY]
	@NAMHOC INT,
	@HK INT
AS
DECLARE @ngayht DATE = CAST(GETDATE() AS DATE)
DECLARE @ngaymodk DATE
DECLARE @ngaydodk DATE
DECLARE @mankhk INT = NULL;
SET XACT_ABORT ON;
BEGIN
	SELECT @mankhk = MANKHK, @ngaymodk = NGAYMODK, @ngaydodk = NGAYDONGDK FROM NKHK WHERE NAMHOC = @NAMHOC AND HK = @HK
	IF @mankhk IS NULL
	BEGIN
		RAISERROR(N'Niên khóa học kỳ không tồn tại!', 16, 1)
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

	IF  NOT(@ngaymodk <= @ngayht AND @ngayht< @ngaydodk)
				RAISERROR( N'Ngoài thời gian đăng ký!', 16, 1)
END
GO

