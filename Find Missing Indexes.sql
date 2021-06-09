USE [msdb]  /*Replace with your Database Name */
GO
SELECT TOP 50 
    GETDATE() AS [RunTime],
    DB_NAME(mid.database_id) AS [DBNAME], 
    OBJECT_NAME(mid.[object_id]) AS [ObjectName], mid.[object_id] AS [ObjectID],
    CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) AS [Improvement_Measure],
    'CREATE INDEX missing_index_' + CONVERT (varchar, mig.index_group_handle) + '_' + CONVERT (varchar, mid.index_handle) 
    + ' ON ' + mid.statement 
    + ' (' + ISNULL (mid.equality_columns,'') 
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END + ISNULL (mid.inequality_columns, '')
    + ')' 
    + ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS [CREATE_INDEX_Statement],
    migs.user_seeks, migs.user_scans, migs.last_user_seek, migs.last_user_scan, migs.avg_total_user_cost, migs.avg_user_impact, migs.avg_system_impact,
    mig.index_group_handle, mid.index_handle
FROM sys.dm_db_missing_index_groups mig
    INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
    INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) > 10
    AND mid.database_id = DB_ID()
ORDER BY [Improvement_Measure] DESC
GO