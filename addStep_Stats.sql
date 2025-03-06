USE [msdb]
GO
/****** Object:  Step [IndexOptimize - USER_DATABASES]    Script Date: 6/20/2022 4:21:23 PM ******/
EXEC msdb.dbo.sp_delete_jobstep @job_name=N'IndexOptimize - USER_DATABASES', @step_id=1
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'IndexOptimize - USER_DATABASES', @step_name=N'IndexOptimize - USER_DATABASES', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.IndexOptimize
@Databases = ''USER_DATABASES'',
@FragmentationLow = NULL,
@FragmentationMedium = ''INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE'',
@FragmentationHigh = ''INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE'',
@FragmentationLevel1 = 5,
@FragmentationLevel2 = 30,
@LogToTable = ''Y''', 
		@database_name=N'master', 
		@output_file_name=N'$(ESCAPE_SQUOTE(SQLLOGDIR))\IndexOptimize_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(DATE))_$(ESCAPE_SQUOTE(TIME)).txt', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'IndexOptimize - USER_DATABASES', @step_name=N'UpdateStatistics - USER_DATABASES', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.IndexOptimize
@Databases = ''USER_DATABASES'',
@FragmentationLow = NULL,
@FragmentationMedium = NULL,
@FragmentationHigh = NULL,
@UpdateStatistics = ''ALL'',
@LogToTable = ''Y''', 
		@database_name=N'master', 
		@flags=0
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_update_jobstep @job_name=N'IndexOptimize - USER_DATABASES', @step_id=1 , 
		@on_success_action=4, 
		@on_success_step_id=2
GO
