@ECHO OFF
:REM to install, run this in c:\batch
:REM curl -o t.cmd https://robertt-smg.github.io/ansible-bootstrap/t.cmd
SETLOCAL
:# Start airQuest Terminal Session

if not exist "C:\tmp\airQuest" mkdir -p "C:\tmp\airQuest"
curl -o C:\tmp\airQuest\airquest.ico https://robertt-smg.github.io/ansible-bootstrap/airquest.ico
curl -o C:\tmp\airQuest\get_sid.vbs https://robertt-smg.github.io/ansible-bootstrap/get_sid.vbs


setlocal enabledelayedexpansion

set "TEMPFILE=sid.tmp"

set "USER=%*"
if ["%USER%"] == [""]  (
   echo Using default user %USERNAME% as argument
   set "USER=%USERNAME%"
) else (
   echo Using passed user as argument %USER%
   
)
if [%LOGONSERVER%] == [\\DC1]  (
   rem SID und Username mit get_sid.vbs ermitteln
   set "SID="
   set "SAMACCOUNTNAME="
   rem SID und Username mit get_sid.vbs ermitteln
   for /f "delims=" %%A in ('cscript //nologo C:\tmp\airQuest\get_sid.vbs "%USER%"') do call %%A
) 

if not defined SID (
   set "TEMPFILE=sid.tmp"

   echo SID mit whoami /user ermitteln
   set "SID="
   for /f "tokens=2" %%S in ('C:\Windows\System32\whoami.exe /user /nh') do (
      set "SID=%%S"
      set "SAMACCOUNTNAME=%USERNAME%"
   )
)
if not [%LOGONSERVER%] == [\\DC1]  (
    rem Set SAMACCOUNTNAME based on SID static table
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-13875" set "SAMACCOUNTNAME=robertt"
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-14736" set "SAMACCOUNTNAME=alexandrarab"
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-14743" set "SAMACCOUNTNAME=guidoa"
    if "%SID%"=="S-1-5-21-2118902758-2007634129-3050185254-1002" ( # lokales Konto

      set SID="S-1-5-21-1214440339-1383384898-1060284298-13878" 
      set "SAMACCOUNTNAME=sandrakr"
    )
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-14735" set "SAMACCOUNTNAME=patrickde"
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-13194" set "SAMACCOUNTNAME=stefankr"
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-13874" set "SAMACCOUNTNAME=sarahb"
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-12136" set "SAMACCOUNTNAME=malter"
    if "%SID%"=="S-1-5-21-4160103547-2117186805-284825804-1005" ( # lokales Konto
      set SID="S-1-5-21-1214440339-1383384898-1060284298-14643" 
      set "SAMACCOUNTNAME=Biancag"
    )
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-11201" set "SAMACCOUNTNAME=manuelat"
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-13898" set "SAMACCOUNTNAME=markussc"
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-13915" set "SAMACCOUNTNAME=annad"
    if "%SID%"=="S-1-5-21-1214440339-1383384898-1060284298-14771" set "SAMACCOUNTNAME=hannelorese"
)

if not defined SAMACCOUNTNAME (
    msg * User: '%USER%' wurde nicht gefunden, SAMACCOUNTNAME konnte nicht ermittelt werden
    goto :eof
)

if not defined SID (
    msg * User: '%USER%' wurde nicht gefunden, SID konnte nicht ermittelt werden
    goto :eof
)

if defined SID (
   echo %SID%> "%TEMPFILE%"
   set "HASH="
   for /f "skip=1 tokens=1" %%H in ('certutil -hashfile "%TEMPFILE%" MD5') do (
      if not defined HASH ( 
         set "HASH=%%H"
      )
   )
   set "sPass=!HASH!@SMG"
   
) 

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
set "sServer=%TS_SERVER%"
if [%sServer%] == []  (
    set "sServer=t01.smg-air-conso.com"
)
set "sUser=%SAMACCOUNTNAME%"


%heredoc% :rdp_file %rdpFile%
allow desktop composition:i:0
allow font smoothing:i:0
alternate shell:s:||run_airquest
audiocapturemode:i:0
audiomode:i:0
authentication level:i:2
autoreconnection enabled:i:1
bandwidthautodetect:i:0
bitmapcachepersistenable:i:1
compression:i:1
connection type:i:2
desktopheight:i:600
desktopwidth:i:800
disable cursor setting:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:1
disable wallpaper:i:1
displayconnectionbar:i:1
drivestoredirect:s:*
enablerdsaadauth:i:0
enableworkspacereconnect:i:0
full address:s:!sServer!
gatewaybrokeringtype:i:0
gatewaycredentialssource:i:0
gatewayhostname:s:
gatewayprofileusagemethod:i:0
gatewayusagemethod:i:2
kdcproxyname:s:
keyboardhook:i:2
negotiate security layer:i:1
networkautodetect:i:0
prompt for credentials on client:i:0
prompt for credentials:i:0
promptcredentialonce:i:1
rdgiskdcproxy:i:0
redirectclipboard:i:1
redirectcomports:i:1
redirectdirectx:i:1
redirectlocation:i:0
redirectposdevices:i:1
redirectprinters:i:1
redirectsmartcards:i:0
redirectwebauthn:i:1
remoteapplicationcmdline:s:
remoteapplicationicon:s:
remoteapplicationmode:i:1
remoteapplicationname:s:run_airquest.cmd
remoteapplicationprogram:s:||run_airquest
remoteappmousemoveinject:i:1
screen mode id:i:2
server port:i:3389
session bpp:i:32
shell working directory:s:d:\data
span monitors:i:0
use multimon:i:1
use redirection server name:i:0
username:s:!SAMACCOUNTNAME!
videoplaybackmode:i:1
winposstr:s:0,3,0,0,800,600
:rdp_file

:rem type "%rdpFile%" 


:: Add a new connection definition method to the vault
cmdkey /generic:TERMSRV/%sServer% /user:%sUser% /pass:%sPass%
echo Benutzer: %SAMACCOUNTNAME% (%SID%) wird verbunden .... bitte warten ...

:type %rdpFile%  
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