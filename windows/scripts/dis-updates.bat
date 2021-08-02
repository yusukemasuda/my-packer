REM http://www.windows-commandline.com/disable-automatic-updates-command-line/

REM --------------------------------------------------------
REM  Disable WIndows Update
REM --------------------------------------------------------
REM  - AUOptions:
REM     1: Keep my computer up to date is disabled in Automatic Updates.
REM     2: Notify of download and installation.
REM     3: Automatically download and notify of installation.
REM     4: Automatically download and scheduled installation.
REM --------------------------------------------------------

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f

REM --------------------------------------------------------
REM   Remove optional WSUS server settings
REM --------------------------------------------------------

REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" > nul 2>&1
IF %ERRORLEVEL% == 0 (
  REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f
)


REM Even harder, disable windows update service
REM SC CONFIG WUAUSERV Start=Disabled
REM NET STOP WUAUSERV
SET logfile=C:\Windows\Temp\Win-Updates.log

IF EXIST %logfile% (
  ECHO Show Windows Updates log file %logfile%
  DIR %logfile%
  TYPE %logfile%
  REM output of type command is not fully shown in packer/ssh session, so try PowerShell
  REM but it will hang if log file is about 22 KByte
  REM powershell -command "Get-Content %logfile%"
  ECHO End of Windows Updates log file %logfile%
)
