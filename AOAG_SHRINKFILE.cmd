@echo off
REM ===============================================
REM Verbindung zu einem AOAG-Listener und SHRINKFILE
REM ===============================================

REM Variablen: Hier anpassen!
SET LISTENER_NAME=AOAG-ListenerName
SET DATABASE_NAME=DeineDatenbank
SET FILE_NAME=DateiName
SET TARGET_SIZE=1000 -- Größe in MB, hier Beispiel: 1000 MB

REM Optional: SQL Server Authentifizierung (nicht empfohlen)
REM SET SQL_USER=DeinBenutzer
REM SET SQL_PASSWORD=DeinPasswort

REM Befehl mit Windows Authentication:
sqlcmd -S %LISTENER_NAME% -d %DATABASE_NAME% -E -Q "DBCC SHRINKFILE (N'%FILE_NAME%', %TARGET_SIZE%);"

REM Befehl mit SQL Authentifizierung (nur wenn benötigt):
REM sqlcmd -S %LISTENER_NAME% -d %DATABASE_NAME% -U %SQL_USER% -P %SQL_PASSWORD% -Q "DBCC SHRINKFILE (N'%FILE_NAME%', %TARGET_SIZE%);"

echo SHRINKFILE abgeschlossen.
pause
