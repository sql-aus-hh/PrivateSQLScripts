DECLARE @ts_now BIGINT

SELECT @ts_now = cpu_ticks / ms_ticks FROM sys.dm_os_sys_info
	SELECT record_id,
		DATEADD(hour, ((@ts_now - TIMESTAMP)/3600000), GETDATE()) AS EventTime,
		SQLProcessUtilization,
		SystemIdle,
		100 - SystemIdle - SQLProcessUtilization AS OtherProcessUtilization
	FROM (
		SELECT
			record.value('(./Record/@id)[1]', 'int') AS record_id,
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemIdle,
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization,
			TIMESTAMP
		FROM (
			SELECT TIMESTAMP, CONVERT(XML, record) AS record
			FROM sys.dm_os_ring_buffers
			WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
			AND record LIKE '% %') AS x
		) AS y
	ORDER BY record_id DESC