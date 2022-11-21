declare @loginName varchar (100) 
declare @password varchar (100)
declare @SqlStatement2 nvarchar(4000)
declare @SqlStatement3 nvarchar(4000)
declare @ver int

set @loginName = 'tidal'
set @password  = 'Dev/12345'
select @ver = left(cast(SERVERPROPERTY('productversion') as varchar(50)), charindex('.', cast(SERVERPROPERTY('productversion') as varchar(50)))-1)

declare @dbname varchar (100) 

if @ver <= 8 --For SQL 2000 and lower
BEGIN
	DECLARE db_cursor CURSOR FOR
	SELECT name
	FROM master.dbo.sysdatabases
	where DATABASEPROPERTYEX(name, 'Status') = 'ONLINE'
END

if @ver > 8 --For SQL 2005 and higher
BEGIN
	DECLARE db_cursor CURSOR FOR
	SELECT name
	FROM master.sys.databases
	WHERE name NOT IN ('tempdb')
	 and state_desc = 'online'
	 and is_read_only =0
END

--Creating SQL login and DB users in every database on the instance

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @dbname
WHILE @@FETCH_STATUS = 0 
BEGIN 
	declare @SqlStatement nvarchar(4000)
	Set @SqlStatement =
	CASE WHEN @ver <= 8 --For SQL 2000 only
		THEN'IF NOT EXISTS 
			(SELECT name  
				FROM master.dbo.syslogins
				WHERE name = '''+@loginName +''') 
			EXEC sp_addlogin @loginame=''' + @loginName + ''', @passwd='''+ @password +''', @defdb=[master]
			use [' + @dbname + ']; 
			IF NOT EXISTS (SELECT [name]
						FROM [dbo].[sysusers]
						WHERE [islogin] = 1 AND [isntname] = 0 AND [name] = ''' + @loginName +''')
						exec sp_adduser @loginame=''' + @loginName + ''', @name_in_db='''+@loginName +''';'
		ELSE
			'IF NOT EXISTS 
			(SELECT name  
				FROM master.sys.server_principals
				WHERE name = '''+@loginName +''') 
				CREATE LOGIN ['+@loginName +'] WITH PASSWORD = '''+ @password +''' ,DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
			use [' + @dbname + ']; 
			IF NOT EXISTS (SELECT [name]
						FROM [sys].[database_principals]
						WHERE [type] = N''S'' AND [name] = ''' + @loginName +''') 
			CREATE USER ['+ @loginName +'] FOR LOGIN ['+@loginName +'] ;'
	END
	--print @SqlStatement
	EXEC sp_executesql @SqlStatement
	FETCH NEXT FROM db_cursor INTO @dbname
END

--Granting specific permissions

if @ver <= 8 --For SQL 2000 and lower
BEGIN
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysaltfiles TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
  
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.syscolumns TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysobjects TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.syscomments TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysprocesses TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.systypes TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.syslogins TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysobjects TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysservers TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysfilegroups TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysindexes TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysforeignkeys TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysconfigures TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysfiles TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysdatabases TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysdevices TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysconstraints TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.syscolumns TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysprocesses TO ['+@loginName +'];'
	EXEC sp_executesql @SqlStatement2

	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.syslocks TO ['+@loginName +'];'
	EXEC sp_executesql @SqlStatement2

	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON dbo.sysperfinfo TO ['+@loginName +'];'
	EXEC sp_executesql @SqlStatement2

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.restorehistory TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysjobschedules TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysjobsteps TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.log_shipping_primaries TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.log_shipping_secondaries TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysjobs TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysalerts TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysjobschedules TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysjobs TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.backupset TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysalerts  TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysjobs TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysdbmaintplans TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysdbmaintplan_jobs TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 = 'USE MSDB; GRANT SELECT ON dbo.sysdtspackages TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3
END

if @ver > 8 --For SQL 2005 and higher
BEGIN
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.master_files TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
  
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.columns TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.objects TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.sql_modules TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.sysprocesses TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.server_triggers TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.master_files TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.partitions TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.types TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.server_principals TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.syslogins TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.server_permissions TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.triggers TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.objects TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.servers TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.symmetric_keys TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.synonyms TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.dm_os_cluster_nodes TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
  
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.fulltext_index_columns TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.partition_schemes  TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
  
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.partition_functions TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.tables TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.event_notifications TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2

	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.data_spaces TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON master.sys.indexes TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON master.sys.foreign_keys TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.computed_columns TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.configurations TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.credentials TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.database_files TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.filegroups TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.database_mirroring TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.databases TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.assembly_modules TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.asymmetric_keys TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.backup_devices TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.certificates TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.check_constraints TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.columns TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON sys.default_constraints TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement2
 
	Set @SqlStatement2 = 'USE MASTER; GRANT VIEW SERVER STATE TO ['+@loginName +'];'
	EXEC sp_executesql @SqlStatement2

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.log_shipping_secondary_databases TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.restorehistory TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysjobschedules TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysjobsteps TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.log_shipping_primary_databases TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.log_shipping_secondary_databases TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysjobs TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysalerts TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysjobschedules TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysjobs TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.backupset TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.log_shipping_primary_databases TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysalerts  TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysjobs TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysmaintplan_plans TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3

	Set @SqlStatement3 ='USE MSDB; GRANT SELECT ON dbo.sysmaintplan_subplans TO [' + @loginName + '];'
	EXEC sp_executesql @SqlStatement3
END

--For all versions
Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON INFORMATION_SCHEMA.TABLES TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2

Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON INFORMATION_SCHEMA.COLUMNS  TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2
 
Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON INFORMATION_SCHEMA.PARAMETERS TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2

Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON information_schema.routines TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2
 
Set @SqlStatement2 = 'USE MASTER; GRANT SELECT ON INFORMATION_SCHEMA.VIEWS TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2
 
Set @SqlStatement2 = 'USE MASTER; IF OBJECT_ID (N''sys.server_event_sessions'') IS NOT NULL GRANT SELECT ON sys.server_event_sessions TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2
 
Set @SqlStatement2 = 'USE MASTER; IF OBJECT_ID (N''sys.resource_governor_configuration'') IS NOT NULL GRANT SELECT ON sys.resource_governor_configuration TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2
 
Set @SqlStatement2 = 'USE MASTER; IF OBJECT_ID (N''sys.sequences'') IS NOT NULL GRANT SELECT ON sys.sequences TO [' + @loginName +'];'
EXEC sp_executesql @SqlStatement2

Set @SqlStatement2 = 'USE MASTER; IF OBJECT_ID (N''sys.server_audits'') IS NOT NULL GRANT SELECT ON sys.server_audits TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2

Set @SqlStatement2 = 'USE MASTER; IF OBJECT_ID (N''sys.hash_indexes'') IS NOT NULL GRANT SELECT ON sys.hash_indexes TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2
  
Set @SqlStatement2 = 'USE MASTER; IF OBJECT_ID (N''sys.masked_columns'') IS NOT NULL GRANT SELECT ON sys.masked_columns TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2
 
Set @SqlStatement2 = 'USE MASTER; IF OBJECT_ID (N''sys.filetables'') IS NOT NULL GRANT SELECT ON sys.filetables TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2
 
Set @SqlStatement2 = 'USE MASTER; IF OBJECT_ID (N''sys.fn_db_backup_file_snapshots'') IS NOT NULL GRANT SELECT ON sys.fn_db_backup_file_snapshots TO [' + @loginName + '];'
EXEC sp_executesql @SqlStatement2

CLOSE db_cursor
deallocate db_cursor
