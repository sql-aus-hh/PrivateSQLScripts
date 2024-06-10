## Install-Module dbatools

$ComputerName = $env:COMPUTERNAME
$InstanceName = ""
if ($InstanceName -ne "") {
    $SqlInstance = "$ComputerName\$InstanceName"
} else {
    $SqlInstance = $ComputerName
}
$Port = 6201

Set-DbatoolsConfig -FullName sql.connection.trustcert -Value $true -Register
Set-DbatoolsConfig -FullName sql.connection.encrypt -Value $false -Register
Set-DbatoolsConfig -Name Import.EncryptionMessageCheck -Value $false -PassThru | Register-DbatoolsConfig

## Set-DbaPrivilege -Type BatchLogon,LPIM,IFI
## AUSFÜHRLICH: Added NT Service\MSSQLSERVER to Batch Logon Privileges on LOGIPET-WMSSQL
## AUSFÜHRLICH: NT Service\MSSQLSERVER already has Instant File Initialization Privilege on LOGIPET-WMSSQL
## AUSFÜHRLICH: Added NT Service\MSSQLSERVER to Lock Pages in Memory Privileges on LOGIPET-WMSSQL

## Get-Service | Where-object {$_.DisplayName -like "*CEIP*"} | Set-Service -StartupType Disabled -Status Stopped

## BEGINN Instance Config
Set-DbaTcpPort -SqlInstance $SqlInstance -Port $Port

## ComputerName  : LOGIPET-WMSSQL
## InstanceName  : MSSQLSERVER
## SqlInstance   : LOGIPET-WMSSQL
## Changes       : {Changed TcpPort for IPAll to 6201}
## RestartNeeded : True
## Restarted     : False

netsh advfirewall firewall add rule name="SQL Server $InstanceName (TCP $Port)" dir=in action=allow protocol=TCP localport=$Port profile=domain
netsh advfirewall firewall add rule name="SQL Service Broker (TCP 4022)" dir=in action=allow protocol=TCP localport=4022 profile=domain
netsh advfirewall firewall add rule name="SQL Browser (UDP 1434)" dir=in action=allow protocol=UDP localport=1434 profile=domain
## OK.
## OK.
## OK.

## 89% von 10GB sind 9104
## 89% von 40GB sind 36454
## 89% von 50GB sind 45568
## 89% von 80GB sind 72908

[int]$NoOfProcs = $env:NUMBER_OF_PROCESSORS
if ($NoOfProcs -ge "8") { $NoOfProcs = 8 }
Set-DbaTempDbConfig -SqlInstance $SQLInstance -DataFileCount $NoOfProcs -DataFileSize 226928 -DataFileGrowth 0

## ComputerName       : logipet-wmssql
## InstanceName       : MSSQLSERVER
## SqlInstance        : logipet-wmssql
## DataFileCount      : 4
## DataFileSize       : 221,61 GB
## SingleDataFileSize : 55,40 GB
## LogSize            : 8,00 MB
## DataPath           : {G:\TempDB}
## LogPath            : F:\TLog
## DataFileGrowth     : 0 B
## LogFileGrowth      : 512,00 MB

Set-DbaMaxDop -SqlInstance $SQLInstance -MaxDop $NoOfProcs

## ComputerName                : logipet-wmssql
## InstanceName                : MSSQLSERVER
## SqlInstance                 : logipet-wmssql
## PreviousInstanceMaxDopValue : 4
## CurrentInstanceMaxDop       : 4

Get-DbaSpConfigure -SqlInstance $SQLInstance -Name 'CostThresholdForParallelism' | Set-DbaSpConfigure -Value 40

## ComputerName  : logipet-wmssql
## InstanceName  : MSSQLSERVER
## SqlInstance   : logipet-wmssql
## ConfigName    : CostThresholdForParallelism
## PreviousValue : 5
## NewValue      : 40

Test-DbaMaxMemory -SqlInstance $SQLInstance
$RecMinValue = ((Test-DbaMaxMemory -SqlInstance $SQLInstance).RecommendedValue/2)
$RecMaxValue = (Test-DbaMaxMemory -SqlInstance $SQLInstance).RecommendedValue
Get-DbaSpConfigure -SqlInstance $SQLInstance -Name 'MinServerMemory' | Set-DbaSpConfigure -Value $RecMinValue
Get-DbaSpConfigure -SqlInstance $SQLInstance -Name 'MaxServerMemory' | Set-DbaSpConfigure -Value $RecMaxValue

## ComputerName     : logipet-wmssql
## InstanceName     : MSSQLSERVER
## SqlInstance      : logipet-wmssql
## InstanceCount    : 1
## Total            : 131072
## MaxValue         : 97280
## RecommendedValue : 111616
## 
## ComputerName  : logipet-wmssql
## InstanceName  : MSSQLSERVER
## SqlInstance   : logipet-wmssql
## ConfigName    : MinServerMemory
## PreviousValue : 0
## NewValue      : 55808
## 
## ComputerName  : logipet-wmssql
## InstanceName  : MSSQLSERVER
## SqlInstance   : logipet-wmssql
## ConfigName    : MaxServerMemory
## PreviousValue : 97280
## NewValue      : 111616

Get-DbaSpConfigure -SqlInstance $SQLInstance -Name 'OptimizeAdhocWorkloads' | Set-DbaSpConfigure -Value $true
Get-DbaSpConfigure -SqlInstance $SQLInstance -Name 'DefaultBackupCompression' | Set-DbaSpConfigure -Value $true
Get-DbaSpConfigure -SqlInstance $SQLInstance -Name 'NetworkPacketSize' | Set-DbaSpConfigure -Value 8192

## ComputerName  : logipet-wmssql
## InstanceName  : MSSQLSERVER
## SqlInstance   : logipet-wmssql
## ConfigName    : OptimizeAdhocWorkloads
## PreviousValue : 0
## NewValue      : 1
## 
## ComputerName  : logipet-wmssql
## InstanceName  : MSSQLSERVER
## SqlInstance   : logipet-wmssql
## ConfigName    : DefaultBackupCompression
## PreviousValue : 0
## NewValue      : 1
## 
## ComputerName  : logipet-wmssql
## InstanceName  : MSSQLSERVER
## SqlInstance   : logipet-wmssql
## ConfigName    : NetworkPacketSize
## PreviousValue : 4096
## NewValue      : 8192

Install-DbaMaintenanceSolution -SqlInstance $SQLInstance -ReplaceExisting -LogToTable -InstallJobs -CleanupTime 168
## Invoke-DbaQuery -SqlInstance $SQLInstance -File "D:\_install\MaintenanceSolution.sql"

## ComputerName   InstanceName SqlInstance    Results
## ------------   ------------ -----------    -------
## logipet-wmssql MSSQLSERVER  logipet-wmssql Success

Invoke-DbaQuery -SqlInstance $SQLInstance -File "D:\_install\SetSYSTEMUserToSysadmin.sql"
Invoke-DbaQuery -SqlInstance $SQLInstance -File "D:\_install\SetNumberErrorLogs.sql"
Invoke-DbaQuery -SqlInstance $SQLInstance -File "D:\_install\RecylceErrorlog.sql"
Invoke-DbaQuery -SqlInstance $SQLInstance -File "D:\_install\Hinzufügen von Update Statistics.txt"
& 'D:\_install\Create and Attach Schedules to AgentJobs.ps1' $SQLInstance

Backup-DbaDatabase -SqlInstance $SQLInstance -Database master, msdb
Export-DbaInstance -SqlInstance $SQLInstance -Path "D:\_install\"

## SqlInstance    Database Type TotalSize DeviceType Start                   Duration End                    
## -----------    -------- ---- --------- ---------- -----                   -------- ---                    
## logipet-wmssql master   Full 4,77 MB   Disk       2024-05-29 15:50:43.000 00:00:00 2024-05-29 15:50:43.000
## logipet-wmssql msdb     Full 18,10 MB  Disk       2024-05-29 15:50:43.000 00:00:00 2024-05-29 15:50:43.000

Start-DbaAgentJob -SqlInstance $SqlInstance -Job 'DatabaseBackup - SYSTEM_DATABASES - FULL'

Restart-DbaService -ComputerName $ComputerName
