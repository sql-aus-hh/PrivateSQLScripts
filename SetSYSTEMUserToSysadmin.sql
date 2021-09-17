IF EXISTS (SELECT name 
                FROM [sys].[server_principals]
                WHERE name = N'NT-AUTORITÄT\SYSTEM')
Begin
	ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT-AUTORITÄT\SYSTEM]
End

IF EXISTS (SELECT name 
                FROM [sys].[server_principals]
                WHERE name = N'NT AUTHORITY\SYSTEM')
Begin
	ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT AUTHORITY\SYSTEM]
End