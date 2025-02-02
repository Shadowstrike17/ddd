@echo off
title v3nom Console
cls
:: Set Green Hacker Theme
color 0A  

:: Display ASCII Art
echo.
echo  ██╗   ██╗███████╗███╗   ██╗ ██████╗ ███╗   ███╗
echo  ██║   ██║██╔════╝████╗  ██║██╔═══██╗████╗ ████║
echo  ██║   ██║█████╗  ██╔██╗ ██║██║   ██║██╔████╔██║
echo  ██║   ██║██╔══╝  ██║╚██╗██║██║   ██║██║╚██╔╝██║
echo  ╚██████╔╝███████╗██║ ╚████║╚██████╔╝██║ ╚═╝ ██║
echo   ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝
echo.
echo  -=[ Welcome to V3nom Command Console ]=-
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
if "%input%" EQU "" goto :prompt

goto :prompt

:wifipassword
echo.
for /F "tokens=2 delims=:" %%a in ('netsh wlan show profile') do (
    set wifi_pwd=
    for /F "tokens=2 delims=: usebackq" %%F IN (`netsh wlan show profile %%a key^=clear ^| find "Key Content"`) do (
        echo %%a: %%F
    )
)
echo.
goto :prompt

:pcinfo
echo.
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "OS Name"') do set osname=%%~a
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "System Manufacturer"') do set manufacture=%%~a
set osname=%osname:~19%
set manufacture=%manufacture:~7%
echo.
echo Username: %username%
echo Hostname: %computername%
echo OS: %osname%
echo Manufacturer: %manufacture%
echo.
goto :prompt

:geolocate
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
echo Would you like to shutdown (s) or restart (r)?
set /p choice="Your choice > "
if /i "%choice%" EQU "s" (
    shutdown /s /t 0
) else if /i "%choice%" EQU "r" (
    shutdown /r /t 0
) else (
    echo Invalid choice. Returning to menu.
)
echo.
goto :prompt

:revshell
echo.
echo Entering remote shell. Type "exit" to quit.
call cmd.exe
goto :prompt

:menu
echo.
echo ============[ Menu ]=============
echo 1) WiFi password recovery
echo 2) PC info
echo 3) Geolocation
echo 4) PC management
echo 5) Remote shell
echo =================================
echo.
goto :prompt
