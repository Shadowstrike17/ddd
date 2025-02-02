@echo off
title v3nom Console
cls
:: Set Green Hacker Theme
color 0A

:: Display Enhanced ASCII Art
echo.
echo  ██╗   ██╗███████╗███╗   ██╗ ██████╗ ███╗   ███╗
echo  ██║   ██║██╔════╝████╗  ██║██╔═══██╗████╗ ████║
echo  ██║   ██║█████╗  ██╔██╗ ██║██║   ██║██╔████╔██║
echo  ██║   ██║██╔══╝  ██║╚██╗██║██║   ██║██║╚██╔╝██║
echo  ╚██████╔╝███████╗██║ ╚████║╚██████╔╝██║ ╚═╝ ██║
echo   ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝
echo.
echo  -=[ Welcome to V3nom Enhanced Command Console ]=-
echo  -=[ Educational and Demonstrational Purposes Only ]=-
echo.

:prompt
echo.
set /p input="v3nom > "

if "%input%" EQU "help" goto :menu
if "%input%" EQU "1" goto :wifipassword
if "%input%" EQU "2" goto :pcinfo
if "%input%" EQU "3" goto :geolocate
if "%input%" EQU "4" goto :pcmanage
if "%input%" EQU "5" goto :revshell
if "%input%" EQU "6" goto :keylogger
if "%input%" EQU "7" goto :portscan
if "%input%" EQU "8" goto :filehider
if "%input%" EQU "9" goto :netstats
if "%input%" EQU "10" goto :clearlogs
if "%input%" EQU "" goto :prompt

goto :prompt

:wifipassword
echo.
echo [*] Extracting WiFi Passwords...
echo.
for /F "tokens=2 delims=:" %%a in ('netsh wlan show profile') do (
    set wifi_pwd=
    for /F "tokens=2 delims=: usebackq" %%F IN (`netsh wlan show profile %%a key^=clear ^| find "Key Content"`) do (
        echo [*] SSID: %%a | Password: %%F
    )
)
echo.
goto :prompt

:pcinfo
echo.
echo [*] Gathering System Information...
echo.
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "OS Name"') do set osname=%%~a
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "System Manufacturer"') do set manufacture=%%~a
set osname=%osname:~19%
set manufacture=%manufacture:~7%
echo.
echo [*] Username: %username%
echo [*] Hostname: %computername%
echo [*] OS: %osname%
echo [*] Manufacturer: %manufacture%
echo.
goto :prompt

:geolocate
echo.
echo [*] Fetching Geolocation Data...
echo.
setlocal enabledelayedexpansion
FOR /F %%a in ('curl -s ifconfig.me/ip') do set ip=%%a
curl -s http://ipinfo.io/%ip%/json>>%appdata%\Publish.txt

for /f "tokens=* delims= " %%X in (%appdata%\Publish.txt) DO (
    set line=%%X
    set line=!line:"=!
    echo !line!
)
del %appdata%\Publish.txt
goto :prompt

:pcmanage
echo.
echo [*] PC Management Options:
echo.
echo 1) Shutdown
echo 2) Restart
echo 3) Logoff
echo 4) Abort Shutdown
echo.
set /p choice="Your choice > "
if /i "%choice%" EQU "1" (
    shutdown /s /t 0
) else if /i "%choice%" EQU "2" (
    shutdown /r /t 0
) else if /i "%choice%" EQU "3" (
    shutdown /l
) else if /i "%choice%" EQU "4" (
    shutdown /a
) else (
    echo [*] Invalid choice. Returning to menu.
)
echo.
goto :prompt

:revshell
echo.
echo [*] Entering Remote Shell. Type "exit" to quit.
echo.
call cmd.exe
goto :prompt

:keylogger
echo.
echo [*] Keylogger functionality is not supported in this version.
echo [*] Returning to menu.
echo.
goto :prompt

:portscan
echo.
echo [*] Port Scanning Target IP:
set /p target="Enter IP > "
FOR /L %%i IN (1,1,65535) DO (
    timeout 1 >nul
    echo Scanning port %%i...
    START /B telnet %target% %%i
)
echo.
goto :prompt

:filehider
echo.
echo [*] File Hider:
set /p file="Enter file path > "
attrib +h +s +r "%file%"
echo [*] File hidden successfully.
echo.
goto :prompt

:netstats
echo.
echo [*] Displaying Network Statistics...
echo.
netstat -an
echo.
goto :prompt

:clearlogs
echo.
echo [*] Clearing Event Logs...
echo.
wevtutil cl Application
wevtutil cl System
wevtutil cl Security
echo [*] Event logs cleared.
echo.
goto :prompt

:menu
echo.
echo ============[ Enhanced Menu ]=============
echo 1) WiFi Password Recovery
echo 2) PC Info
echo 3) Geolocation
echo 4) PC Management
echo 5) Remote Shell
echo 6) Keylogger (Placeholder)
echo 7) Port Scanner
echo 8) File Hider
echo 9) Network Statistics
echo 10) Clear Event Logs
echo ==========================================
echo.
goto :prompt
