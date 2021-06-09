USE [KDG01]
GO

/****** Object:  Index [_dta_index_dBObjNode_5_197575742__K4_K3_1_2_5_6_7_8_9_10]    Script Date: 28.08.2019 12:54:52 ******/
DROP INDEX [_dta_index_dBObjNode_5_197575742__K4_K3_1_2_5_6_7_8_9_10] ON [dbo].[dbObjNode]
GO

/****** Object:  Index [_dta_index_dBObjNode_5_197575742__K4_K3_1_2_5_6_7_8_9_10]    Script Date: 28.08.2019 12:54:52 ******/
CREATE NONCLUSTERED INDEX [_dta_index_dBObjNode_5_197575742__K4_K3_1_2_5_6_7_8_9_10] ON [dbo].[dbObjNode]
(
	[ObjtypeID] ASC,
	[ObjID] ASC
)
INCLUDE([UserID],[ParentID],[DevID],[ExtID],[ReadOnly],[Dirty],[Deleted],[InUse]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [THIRD]
GO










EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'network packet size (B)', N'8192'
GO
EXEC sys.sp_configure N'cost threshold for parallelism', N'40'
GO
EXEC sys.sp_configure N'optimize for ad hoc workloads', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO




SELECT ISNULL(dbo.dbObjUid.uid, -1) AS [Uid], dbo.dBObject.ObjID, dbo.dBObject.ObjTypeID, dbo.dBObject.ObjSize, dbo.dBObject.Status, dbo.dBObject.ObjDate
           	FROM dbo.dBObjNode INNER JOIN dbo.dBObject ON dbo.dBObject.ObjID = dbo.dBObjNode.ObjID AND dbo.dBObject.ObjTypeID = dbo.dBObjNode.ObjtypeID 		
               LEFT JOIN dbo.dbObjUid ON dbo.dbobjuid.userid=dbo.dbObjNode.UserID AND dbo.dbObjNode.ParentID = dbo.dbObjUid.parentid AND dbo.dBObjNode.ObjID = dbo.dbObjUid.objid  		
            WHERE (dbo.dbObjNode.UserID=@USERID AND dbo.dbObjNode.ParentID=@FOLDERID AND dbo.dBObjNode.ObjtypeID BETWEEN 31 AND 40)"
