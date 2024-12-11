USE [QLSVTC]
GO

/* Set Default values */
ALTER TABLE SINHVIEN
ADD CONSTRAINT DF_SINHVIEN_PASSWORD DEFAULT '12345678' FOR PASSWORD;
INSERT INTO dbo.LOP (MALOP, TENLOP, KHOAHOC, MAKHOA) 

ALTER TABLE DANGKY
ADD CONSTRAINT DF_DANGKY_HUYDANGKY DEFAULT 0 FOR HUYDANGKY;


/* Insert data */
VALUES 
	(N'D20CQDT01', N'D20 Điện tử 1', 2020, N'VT'),
	(N'D20CQVT01', N'D20 viễn thông 1', 2020, N'VT');
	
	
	
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCDT001', N'Nguyễn Văn', N'A', 1, N'Số 1, Đường ABC, Quận 1', CAST(N'2001-01-01' AS Date), N'D20CQDT01 ', N'N-DT      ', 0, N'password1')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCDT002', N'Trần Thị', N'B', 0, N'Số 2, Đường DEF, Quận 2', CAST(N'2001-02-02' AS Date), N'D20CQDT01 ', N'N-DT      ', 1, N'password2')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCDT003', N'Nguyễn Minh', N'C', 1, N'Số 3, Đường GHI, Quận 3', CAST(N'2001-03-03' AS Date), N'D20CQDT01 ', N'N-DT      ', 0, N'password3')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCDT004', N'Phạm Văn', N'D', 1, N'Số 4, Đường JKL, Quận 4', CAST(N'2001-04-04' AS Date), N'D20CQDT01 ', N'N-DT      ', 1, N'password4')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCDT005', N'Nguyễn Thị', N'E', 0, N'Số 5, Đường MNO, Quận 5', CAST(N'2001-05-05' AS Date), N'D20CQDT01 ', N'N-DT      ', 0, N'password5')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCDT006', N'Trần Văn', N'F', 1, N'Số 6, Đường PQR, Quận 6', CAST(N'2001-06-06' AS Date), N'D20CQDT01 ', N'N-DT      ', 1, N'password6')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCDT007', N'Nguyễn Văn', N'G', 1, N'Số 7, Đường STU, Quận 7', CAST(N'2001-07-07' AS Date), N'D20CQDT01 ', N'N-DT      ', 0, N'password7')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCVT001', N'Nguyễn Văn', N'A', 1, N'Số 1, Đường ABC, Quận 1', CAST(N'2001-01-01' AS Date), N'D20CQVT01 ', N'N-VT      ', 0, N'password1')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCVT002', N'Trần Thị', N'B', 0, N'Số 2, Đường DEF, Quận 2', CAST(N'2001-02-02' AS Date), N'D20CQVT01 ', N'N-VT      ', 1, N'password2')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCVT003', N'Nguyễn Minh', N'C', 1, N'Số 3, Đường GHI, Quận 3', CAST(N'2001-03-03' AS Date), N'D20CQVT01 ', N'N-VT      ', 0, N'password3')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCVT004', N'Phạm Văn', N'D', 1, N'Số 4, Đường JKL, Quận 4', CAST(N'2001-04-04' AS Date), N'D20CQVT01 ', N'N-VT      ', 1, N'password4')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCVT005', N'Nguyễn Thị', N'E', 0, N'Số 5, Đường MNO, Quận 5', CAST(N'2001-05-05' AS Date), N'D20CQVT01 ', N'N-VT      ', 0, N'password5')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCVT006', N'Trần Văn', N'F', 1, N'Số 6, Đường PQR, Quận 6', CAST(N'2001-06-06' AS Date), N'D20CQVT01 ', N'N-VT      ', 1, N'password6')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [PHAI], [DIACHI], [NGAYSINH], [MALOP], [MACN], [DANGHIHOC], [PASSWORD]) VALUES (N'D20DCVT007', N'Nguyễn Văn', N'G', 1, N'Số 7, Đường STU, Quận 7', CAST(N'2001-07-07' AS Date), N'D20CQVT01 ', N'N-VT      ', 0, N'password7')

INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'VT001     ', 1, N'VT        ', 5, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'VT001     ', 2, N'VT        ', 6, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'VT003     ', 1, N'VT        ', 4, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'VT003     ', 2, N'VT        ', 3, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'VT005     ', 2, N'VT        ', 2, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'VT005     ', 1, N'VT        ', 1, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'DT001     ', 1, N'VT        ', 5, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'DT001     ', 2, N'VT        ', 6, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'DT003     ', 2, N'VT        ', 4, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'DT003     ', 1, N'VT        ', 3, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'DT005     ', 2, N'VT        ', 2, 0)
INSERT [dbo].[LOPTINCHI] (  [MANKHK], [MAMH], [NHOM], [MAKHOA], [SOSVTOITHIEU], [HUYLOP]) VALUES ( 20212, N'DT005     ', 1, N'VT        ', 1, 0)


INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV016     ', 1, 2036)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV016     ', 2, 2037)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV014     ', 5, 2038)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV014     ', 7, 2039)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV012     ', 1, 2040)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV012     ', 4, 2041)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV016     ', 4, 2042)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV016     ', 10, 2043)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV014     ', 11, 2044)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV014     ', 13, 2045)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV012     ', 5, 2046)
INSERT [dbo].[GIANGDAY] (   [MAGV], [MATB], [MALTC]) VALUES (   N'GV012     ', 8, 2047)



-- D19
-- DIỆN TỬ
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2036, N'D19DCDT001', 8, CAST(7.50 AS Numeric(4, 2)), CAST(9.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2036, N'D19DCDT002', 9, CAST(8.00 AS Numeric(4, 2)), CAST(8.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2036, N'D19DCDT003', 7, CAST(6.50 AS Numeric(4, 2)), CAST(7.00 AS Numeric(4, 2)), 0  )

INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2038, N'D19DCDT001', 8, CAST(7.50 AS Numeric(4, 2)), CAST(9.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2038, N'D19DCDT002', 9, CAST(8.00 AS Numeric(4, 2)), CAST(8.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2038, N'D19DCDT003', 7, CAST(6.50 AS Numeric(4, 2)), CAST(7.00 AS Numeric(4, 2)), 0  )

INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2047, N'D19DCDT001', 8, CAST(7.50 AS Numeric(4, 2)), CAST(9.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2047, N'D19DCDT002', 9, CAST(8.00 AS Numeric(4, 2)), CAST(8.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2047, N'D19DCDT003', 7, CAST(6.50 AS Numeric(4, 2)), CAST(7.00 AS Numeric(4, 2)), 0  )
-- VT
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2042, N'D19DCVT001', 6, CAST(5.50 AS Numeric(4, 2)), CAST(6.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2042, N'D19DCVT002', 10, CAST(9.00 AS Numeric(4, 2)), CAST(9.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2042, N'D19DCVT003', 5, CAST(4.00 AS Numeric(4, 2)), CAST(5.50 AS Numeric(4, 2)), 1  )

INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2044, N'D19DCVT001', 6, CAST(5.50 AS Numeric(4, 2)), CAST(6.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2044, N'D19DCVT002', 10, CAST(9.00 AS Numeric(4, 2)), CAST(9.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2044, N'D19DCVT003', 5, CAST(4.00 AS Numeric(4, 2)), CAST(5.50 AS Numeric(4, 2)), 1  )

INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2040, N'D19DCVT001', 6, CAST(5.50 AS Numeric(4, 2)), CAST(6.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2040, N'D19DCVT002', 10, CAST(9.00 AS Numeric(4, 2)), CAST(9.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2040, N'D19DCVT003', 5, CAST(4.00 AS Numeric(4, 2)), CAST(5.50 AS Numeric(4, 2)), 1  )

-- D20
-- DT
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2037, N'D20DCDT001', 8, CAST(7.50 AS Numeric(4, 2)), CAST(9.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2037, N'D20DCDT002', 9, CAST(8.00 AS Numeric(4, 2)), CAST(8.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2037, N'D20DCDT003', 7, CAST(6.50 AS Numeric(4, 2)), CAST(7.00 AS Numeric(4, 2)), 0  )

INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2039, N'D20DCDT001', 8, CAST(7.50 AS Numeric(4, 2)), CAST(9.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2039, N'D20DCDT002', 9, CAST(8.00 AS Numeric(4, 2)), CAST(8.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2039, N'D20DCDT003', 7, CAST(6.50 AS Numeric(4, 2)), CAST(7.00 AS Numeric(4, 2)), 0  )

INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2046, N'D20DCDT001', 8, CAST(7.50 AS Numeric(4, 2)), CAST(9.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2046, N'D20DCDT002', 9, CAST(8.00 AS Numeric(4, 2)), CAST(8.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2046, N'D20DCDT003', 7, CAST(6.50 AS Numeric(4, 2)), CAST(7.00 AS Numeric(4, 2)), 0  )
--VT
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2043, N'D20DCVT001', 6, CAST(5.50 AS Numeric(4, 2)), CAST(6.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2043, N'D20DCVT002', 10, CAST(9.00 AS Numeric(4, 2)), CAST(9.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2043, N'D20DCVT003', 5, CAST(4.00 AS Numeric(4, 2)), CAST(5.50 AS Numeric(4, 2)), 1  )

INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2045, N'D20DCVT001', 6, CAST(5.50 AS Numeric(4, 2)), CAST(6.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2045, N'D20DCVT002', 10, CAST(9.00 AS Numeric(4, 2)), CAST(9.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2045, N'D20DCVT003', 5, CAST(4.00 AS Numeric(4, 2)), CAST(5.50 AS Numeric(4, 2)), 1  )

INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2041, N'D20DCVT001', 6, CAST(5.50 AS Numeric(4, 2)), CAST(6.00 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2041, N'D20DCVT002', 10, CAST(9.00 AS Numeric(4, 2)), CAST(9.50 AS Numeric(4, 2)), 0  )
INSERT [dbo].[DANGKY] ([MALTC], [MASV], [DIEM_CC], [DIEM_GK], [DIEM_CK], [HUYDANGKY]  ) VALUES (2041, N'D20DCVT003', 5, CAST(4.00 AS Numeric(4, 2)), CAST(5.50 AS Numeric(4, 2)), 1  )

