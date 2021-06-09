SELECT	
		SERVERPROPERTY('ServerName') AS [Instance Name],
		CASE LEFT(CONVERT(VARCHAR, SERVERPROPERTY('ProductVersion')),4) 
			WHEN '11.0' THEN 'SQL Server 2012'
			WHEN '12.0' THEN 'SQL Server 2014'
			WHEN '13.0' THEN 'SQL Server 2016'
			WHEN '14.0' THEN 'SQL Server 2017'
			ELSE 'Newer than SQL Server 2017'
		END AS [Version Build],
		SERVERPROPERTY ('Edition') AS [Edition],
		SERVERPROPERTY('ProductLevel') AS [Service Pack],
		SERVERPROPERTY('ProductUpdateLevel') AS [Cum. Update],
		CASE SERVERPROPERTY('IsIntegratedSecurityOnly') 
			WHEN 0 THEN 'SQL Server and Windows Authentication mode'
			WHEN 1 THEN 'Windows Authentication mode'
		END AS [Server Authentication],
		CASE SERVERPROPERTY('IsClustered') 
			WHEN 0 THEN 'False'
			WHEN 1 THEN 'True'
		END AS [Is Clustered?],
		CASE SERVERPROPERTY('IsHadrEnabled') 
			WHEN 0 THEN 'False'
			WHEN 1 THEN 'True'
		END AS [Is AO-AG enabeled?],
		SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS [Current Node Name],
		SERVERPROPERTY('Collation') AS [ SQL Collation],
		[cpu_count] AS [CPUs],
		[physical_memory_kb]/1024 AS [RAM (MB)]
	FROM	
		[sys].[dm_os_sys_info]
