USE [QLSVTC]
GO

/****** Object:  Table [dbo].[LOPTINCHI]    Script Date: 12/4/2024 9:22:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LOPTINCHI](
	[MALTC] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MANKHK] [int] NOT NULL,
	[MAMH] [nchar](10) NOT NULL,
	[NHOM] [int] NOT NULL,
	[MAKHOA] [nchar](10) NOT NULL,
	[SOSVTOITHIEU] [int] NOT NULL,
	[HUYLOP] [bit] NOT NULL CONSTRAINT [DF__LOPTINCHI__HUYLO__29572725]  DEFAULT ('false'),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [MSmerge_df_rowguid_20F5FF59EBD9408692CC12C29D19AE4A]  DEFAULT (newsequentialid()),
 CONSTRAINT [PK__LOPTINCH__7A3D3BC6EBD9AADD] PRIMARY KEY CLUSTERED 
(
	[MALTC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [MANKHK_MAMH_NHOM] UNIQUE NONCLUSTERED 
(
	[MANKHK] ASC,
	[MAMH] ASC,
	[NHOM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LOPTINCHI]  WITH NOCHECK ADD  CONSTRAINT [FK__LOPTINCHI__MAMH__3E52440B] FOREIGN KEY([MAMH])
REFERENCES [dbo].[MONHOC] ([MAMH])
NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].[LOPTINCHI] CHECK CONSTRAINT [FK__LOPTINCHI__MAMH__3E52440B]
GO

ALTER TABLE [dbo].[LOPTINCHI]  WITH NOCHECK ADD  CONSTRAINT [FK_LOPTINCHI_KHOA] FOREIGN KEY([MAKHOA])
REFERENCES [dbo].[KHOA] ([MAKHOA])
NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].[LOPTINCHI] CHECK CONSTRAINT [FK_LOPTINCHI_KHOA]
GO

ALTER TABLE [dbo].[LOPTINCHI]  WITH NOCHECK ADD  CONSTRAINT [FK_LOPTINCHI_NKHK] FOREIGN KEY([MANKHK])
REFERENCES [dbo].[NKHK] ([MANKHK])
NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].[LOPTINCHI] CHECK CONSTRAINT [FK_LOPTINCHI_NKHK]
GO

ALTER TABLE [dbo].[LOPTINCHI]  WITH NOCHECK ADD  CONSTRAINT [CK_LOPTINCHI] CHECK NOT FOR REPLICATION (([SOSVTOITHIEU]>(0) AND [NHOM]>(0)))
GO

ALTER TABLE [dbo].[LOPTINCHI] CHECK CONSTRAINT [CK_LOPTINCHI]
GO

ALTER TABLE [dbo].[LOPTINCHI]  WITH NOCHECK ADD  CONSTRAINT [repl_identity_range_FE960571_E48D_41E3_AD06_512F8FDF1821] CHECK NOT FOR REPLICATION (([MALTC]>(158035) AND [MALTC]<=(159035) OR [MALTC]>(159035) AND [MALTC]<=(160035)))
GO

ALTER TABLE [dbo].[LOPTINCHI] CHECK CONSTRAINT [repl_identity_range_FE960571_E48D_41E3_AD06_512F8FDF1821]
GO
