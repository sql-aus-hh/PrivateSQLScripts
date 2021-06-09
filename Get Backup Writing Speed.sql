SELECT	database_name
		, backup_start_date
		, CASE type
			WHEN 'D' THEN 'FULL'
			WHEN 'I' THEN 'DIFF'
		END 'Type'
		, cast (cast((backup_size / (1024*1024)) as decimal (8,2)) as varchar(32)) + ' MB' 'Backup Size/MB'
		, DATEDIFF(ss, backup_start_date, backup_finish_date) duration
		, cast(round(cast(((backup_size / (1024*1024) / DATEDIFF(ss, backup_start_date, backup_finish_date))) as decimal (8,2)) , 2) as varchar(32)) + ' MB/sec' speed
		-- CAST(CAST((backup_size / (DATEDIFF(ss, backup_start_date, backup_finish_date))) / (1024 * 1024) AS NUMERIC(8, 3)) AS VARCHAR(16)) + ' MB/sec' speed
FROM msdb..backupset where database_name = 'FlowFact'
and DATEDIFF(ss, backup_start_date, backup_finish_date) != 0
and backup_start_date > dateadd(DAY, -14, GETDATE())
and (type = 'D' OR type = 'I')
ORDER BY database_name, backup_start_date desc