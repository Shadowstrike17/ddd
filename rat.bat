@echo off
setlocal enabledelayedexpansion

:: Enable ANSI Escape Sequences
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"

:: Color Definitions
set "red=%ESC%[91m"
set "green=%ESC%[92m"
set "yellow=%ESC%[93m"
set "blue=%ESC%[94m"
set "magenta=%ESC%[95m"
set "cyan=%ESC%[96m"
set "white=%ESC%[97m"
set "reset=%ESC%[0m"

:main
cls
echo %red%██╗   ██╗██████╗ ███╗   ██╗ ██████╗ ███╗   ███╗%reset%
echo %green%██║   ██║╚════██╗████╗  ██║██╔═══██╗████╗ ████║%reset%
echo %blue%██║   ██║ █████╔╝██╔██╗ ██║██║   ██║██╔████╔██║%reset%
echo %yellow%╚██╗ ██╔╝██╔═══╝ ██║╚██╗██║██║   ██║██║╚██╔╝██║%reset%
echo %magenta% ╚████╔╝ ███████╗██║ ╚████║╚██████╔╝██║ ╚═╝ ██║%reset%
echo %cyan%  ╚═══╝  ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝%reset%
echo %white%              -= Advanced Toolkit v3.5 =-%reset%
echo.

:prompt
echo %white%[%red%Main Menu%white%]%reset%
echo %green%[1]%reset% WiFi Password Recovery
echo %green%[2]%reset% System Information
echo %green%[3]%reset% Advanced Geolocation
echo %green%[4]%reset% Power Management
echo %green%[5]%reset% Remote Shell Session
echo %green%[6]%reset% System Diagnostics
echo %green%[7]%reset% File Explorer
echo %green%[8]%reset% Process Manager
echo %green%[9]%reset% Network Utilities
echo %green%[H]%reset% Help Menu
echo %green%[0]%reset% Exit
echo.

set "input="
set /p "input=%white%V3NOM%reset% > %cyan%"
echo %reset%

if "%input%"=="1" goto :wifipassword
if "%input%"=="2" goto :sysinfo
if "%input%"=="3" goto :geolocate
if "%input%"=="4" goto :pcmanage
if "%input%"=="5" goto :revshell
if "%input%"=="6" goto :diagnostics
if "%input%"=="7" goto :filexplorer
if "%input%"=="8" goto :processmgr
if "%input%"=="9" goto :networktools
if /i "%input%"=="h" goto :helptext
if "%input%"=="0" exit /b
if "%input%"=="cls" cls & goto main
if "%input%"=="" goto main

echo %red%[!] Invalid option: %input%%reset%
timeout /t 2 /nobreak >nul
goto main

:helptext
cls
echo %white%[%yellow%Help Menu%white%]%reset%
echo.
echo %cyan%Available Commands:%reset%
echo %yellow%1-9%reset% - Select menu option
echo %yellow%cls%reset% - Clear screen
echo %yellow%0%reset%   - Exit program
echo.
echo %cyan%Module Information:%reset%
echo %yellow%[1]%reset% WiFi Password Recovery - Retrieve stored wireless credentials
echo %yellow%[2]%reset% System Information - Display detailed system specs
echo %yellow%[3]%reset% Advanced Geolocation - Show geographic location data
echo %yellow%[4]%reset% Power Management - Shutdown/Restart options
echo %yellow%[5]%reset% Remote Shell - Access command prompt
echo %yellow%[6]%reset% System Diagnostics - Check system health
echo %yellow%[7]%reset% File Explorer - Browse and manage files
echo %yellow%[8]%reset% Process Manager - View and control processes
echo %yellow%[9]%reset% Network Utilities - Network testing tools
echo.
pause
goto main

:wifipassword
cls
echo %white%[%green%WiFi Password Recovery%white%]%reset%
echo %yellow%Retrieving stored WiFi credentials...%reset%
echo.
(
    echo ^<WiFiCredentials^>
    for /F "tokens=2 delims=:" %%a in ('netsh wlan show profile') do (
        set wifi_pwd=
        for /F "tokens=2 delims=: usebackq" %%F IN (`netsh wlan show profile %%a key^=clear ^| find "Key Content"`) do (
            echo Network: %%a
            echo Password: %%F
            echo ----------------
        )
    )
    echo ^</WiFiCredentials^>
) > "%userprofile%\Desktop\WiFi_Credentials.txt"
type "%userprofile%\Desktop\WiFi_Credentials.txt"
echo.
echo %green%[+]%reset% Saved to Desktop\WiFi_Credentials.txt
pause
goto main

:sysinfo
cls
echo %white%[%green%System Information%white%]%reset%
echo %yellow%Collecting system data...%reset%
echo.
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "OS Name"') do set osname=%%~a
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "System Manufacturer"') do set manufacture=%%~a
set osname=%osname:~1%
set manufacture=%manufacture:~1%
echo %cyan%Username:%reset% %username%
echo %cyan%Hostname:%reset% %computername%
echo %cyan%OS:%reset% %osname%
echo %cyan%Manufacturer:%reset% %manufacture%
echo %cyan%Architecture:%reset% %PROCESSOR_ARCHITECTURE%
echo %cyan%Memory Usage:%reset%
systeminfo | findstr /C:"Total Physical Memory" /C:"Available Physical Memory"
echo.
pause
goto main

:geolocate
cls
echo %white%[%green%Advanced Geolocation%white%]%reset%
echo %yellow%Retrieving location data...%reset%
echo.
setlocal enabledelayedexpansion
FOR /F %%a in ('curl -s ifconfig.me/ip') do set ip=%%a
curl -s http://ipinfo.io/%ip%/json>>%appdata%\Publish.txt

for /f "tokens=* delims= " %%X in (%appdata%\Publish.txt) DO (
    set line=%%X
    set line=!line:"=!
    echo %cyan%!line!%reset%
)
del %appdata%\Publish.txt
echo.
pause
goto main

:pcmanage
cls
echo %white%[%green%Power Management%white%]%reset%
echo %yellow%[1]%reset% Shutdown System
echo %yellow%[2]%reset% Restart System
echo %yellow%[R]%reset% Return to Main Menu
echo.
set /p choice="%white%Select option: %cyan%"
if /i "%choice%"=="1" (
    shutdown /s /t 5
    echo %red%[!] System will shutdown in 5 seconds...%reset%
) else if /i "%choice%"=="2" (
    shutdown /r /t 5
    echo %red%[!] System will restart in 5 seconds...%reset%
) else if /i "%choice%"=="r" (
    goto main
)
timeout /t 5
goto main

:revshell
cls
echo %white%[%green%Remote Shell Session%white%]%reset%
echo %yellow%Starting command shell...%reset%
echo %red%Type 'exit' to return to main menu%reset%
echo.
cmd /k "prompt %white%$P$G%reset% "
goto main

:diagnostics
cls
echo %white%[%green%System Diagnostics%white%]%reset%
echo %yellow%Running system health checks...%reset%
echo.
echo %cyan%Disk Space:%reset%
wmic logicaldisk get caption,freespace,size /format:list | findstr /r /C:"Caption=.:"
echo.
echo %cyan%Memory Usage:%reset%
systeminfo | findstr /C:"Total Physical Memory" /C:"Available Physical Memory"
echo.
echo %cyan%CPU Usage:%reset%
wmic cpu get loadpercentage /value
echo.
pause
goto main

:filexplorer
:fileloop
cls
echo %white%[%green%File Explorer%white%]%reset%
echo Current Directory: %cd%
echo %yellow%[D]%reset% Directories  %yellow%[F]%reset% Files
dir /ad /b | findstr /n "^"
dir /a-d /b | findstr /n "^"
echo.
set "fchoice="
set /p "fchoice=%white%[N]ew path / [R]eturn / Select item: %cyan%"
if /i "%fchoice%"=="r" goto main
if /i "%fchoice%"=="n" (
    set /p "newdir=Enter new path: "
    cd /d "!newdir!" 2>nul || echo %red%Invalid path!%reset%
    timeout /t 2 /nobreak >nul
    goto fileloop
)
if exist "%cd%\%fchoice%" (
    start "" "%cd%\%fchoice%"
)
goto fileloop

:processmgr
cls
echo %white%[%green%Process Manager%white%]%reset%
tasklist /v
echo.
set "pchoice="
set /p "pchoice=Enter PID to kill or [R]eturn: "
if /i "%pchoice%"=="r" goto main
taskkill /PID %pchoice% /F >nul 2>&1 && echo %green%[+] Process terminated%reset% || echo %red%[!] Failed to kill process%reset%
timeout /t 3 /nobreak >nul
goto main

:networktools
cls
echo %white%[%green%Network Utilities%white%]%reset%
echo %yellow%[1]%reset% Ping Test
echo %yellow%[2]%reset% Traceroute
echo %yellow%[3]%reset% DNS Lookup
echo %yellow%[4]%reset% Port Scanner
echo %yellow%[R]%reset% Return
echo.
set "nchoice="
set /p "nchoice=Select operation: "
if /i "%nchoice%"=="1" (
    set /p "target=Enter host/IP: "
    ping %target%
)
if /i "%nchoice%"=="2" (
    set /p "target=Enter host/IP: "
    tracert %target%
)
if /i "%nchoice%"=="3" (
    set /p "domain=Enter domain: "
    nslookup %domain%
)
if /i "%nchoice%"=="4" (
    set /p "target=Enter target IP: "
    set /p "ports=Enter ports (comma-separated): "
    echo %yellow%Scanning ports...%reset%
    for %%p in (%ports%) do (
        (echo >nul) | telnet %target% %%p 2>nul && echo Port %%p %green%OPEN%reset% || echo Port %%p %red%CLOSED%reset%
    )
)
if /i "%nchoice%"=="r" goto main
pause
goto networktools
