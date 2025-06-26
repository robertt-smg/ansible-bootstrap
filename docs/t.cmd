@ECHO OFF
:REM to install, run this in c:\batch
:REM curl -o t.cmd https://robertt-smg.github.io/ansible-bootstrap/t.cmd
SETLOCAL
:# Start airQuest Terminal Session

if not exist "C:\tmp\airQuest" mkdir "C:\tmp\airQuest"

rem Definition of heredoc macro
setlocal DisableDelayedExpansion
set LF=^


::Above 2 blank lines are required - do not remove
set ^"\n=^^^%LF%%LF%^%LF%%LF%^^"
set heredoc=for %%n in (1 2) do if %%n==2 (%\n%
       for /F "tokens=1,2" %%a in ("!argv!") do (%\n%
          if "%%b" equ "" (call :heredoc %%a) else call :heredoc %%a^>%%b%\n%
          endlocal ^& goto %%a%\n%
       )%\n%
    ) else setlocal EnableDelayedExpansion ^& set argv=

set rdpFile="%TEMP%\airQuest.rdp"
set "sServer=%1"
if [%sServer%] == []  (
    set "sServer=t01.smg-air-conso.com"
)
set sUser=%2
if [%sUser%] == []  (
    set "sUser=%USERNAME%"
)

%heredoc% :rdp_file %rdpFile%
redirectclipboard:i:1
redirectposdevices:i:0
redirectprinters:i:1
redirectcomports:i:1
redirectsmartcards:i:0
drivestoredirect:s:
session bpp:i:32
prompt for credentials on client:i:0
span monitors:i:0
use multimon:i:1
remoteapplicationmode:i:1
server port:i:3389
allow font smoothing:i:0
promptcredentialonce:i:1
authentication level:i:2
gatewayusagemethod:i:2
gatewayprofileusagemethod:i:0
gatewaycredentialssource:i:0
full address:s:!sServer!
alternate shell:s:||run_airquest
remoteapplicationprogram:s:||run_airquest
gatewayhostname:s:
remoteapplicationname:s:run_airquest.cmd
remoteapplicationcmdline:s:
compression:i:1
keyboardhook:i:2
audiocapturemode:i:0
videoplaybackmode:i:1
connection type:i:2
displayconnectionbar:i:1
disable wallpaper:i:1
allow desktop composition:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:1
disable cursor setting:i:0
bitmapcachepersistenable:i:1
audiomode:i:0
redirectdirectx:i:1
autoreconnection enabled:i:1
prompt for credentials:i:0
negotiate security layer:i:1
remoteapplicationicon:s:
shell working directory:s:d:\data
use redirection server name:i:0
screen mode id:i:2
winposstr:s:0,3,0,0,800,600
enableworkspacereconnect:i:0
gatewaybrokeringtype:i:0
rdgiskdcproxy:i:0
kdcproxyname:s:
desktopwidth:i:800
desktopheight:i:600
networkautodetect:i:0
bandwidthautodetect:i:0
username:s:!sUser!
:rdp_file

:rem type "%rdpFile%" 

setlocal enabledelayedexpansion

set "TEMPFILE=sid.tmp"

rem SID mit whoami /user ermitteln
set "SID="
for /f "tokens=2" %%S in ('C:\Windows\System32\whoami.exe /user /nh') do (
   set "SID=%%S"
)

if defined SID (
   echo %SID%> "%TEMPFILE%"
   echo %TEMPFILE%
type "%TEMPFILE%"
    set "HASH="
   for /f "skip=1 tokens=1" %%H in ('certutil -hashfile "%TEMPFILE%" MD5') do (
      if not defined HASH ( 
         set "HASH=%%H"
      )
   )
   set "sPass=!HASH!@SMG"
   
) else (
   echo %%U,SID not found ...
   msg * "Benutzer wurde nicht gefunden ..."
   goto :eof
)

:: Add a new connection definition method to the vault
cmdkey /generic:TERMSRV/%sServer% /user:%sUser% /pass:%sPass%

start mstsc %rdpFile%  

C:\Windows\System32\timeout.exe /t 30
cmdkey /delete:TERMSRV/%sServer%

del "%TEMPFILE%"
del "%rdpFile%"

:rem ####################################################################################################### EOF
goto :eof
:heredoc label
set "skip="
for /F "delims=:" %%a in ('findstr /N "%1" "%~F0"') do (
   if not defined skip (set skip=%%a) else set /A lines=%%a-skip-1
)
for /F "skip=%skip% delims=" %%a in ('findstr /N "^" "%~F0"') do (
   set "line=%%a"
   echo(!line:*:=!
   set /A lines-=1
   if !lines! == 0 exit /B
)
exit /B
rem -------------------------

:eof
cls

: rem https://superuser.com/questions/1756354/windows-defender-credential-guard-does-not-allow-using-saved-credentials-for-r