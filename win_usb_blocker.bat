@echo off
:: ============================================================
::  USB BLOCKER / UNLOCKER - Windows 11
::  Run as Administrator
:: ============================================================
title USB Blocker - Windows 11
color 0A

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo ============================================================
    echo  ERROR: Please run this script as Administrator!
    echo ============================================================
    echo.
    echo Right-click the .bat file and select "Run as administrator"
    pause
    exit /b 1
)

:MENU
cls
echo ============================================================
echo         USB BLOCKER TOOL - Windows 11
echo ============================================================
echo.
echo  [1]  BLOCK   USB Storage Devices
echo  [2]  UNBLOCK USB Storage Devices
echo  [3]  CHECK   Current USB Status
echo  [4]  EXIT
echo.
echo ============================================================
set /p choice=  Enter your choice (1-4): 

if "%choice%"=="1" goto BLOCK
if "%choice%"=="2" goto UNBLOCK
if "%choice%"=="3" goto STATUS
if "%choice%"=="4" goto EXIT
echo Invalid choice. Try again.
pause
goto MENU


:: ============================================================
:BLOCK
:: ============================================================
cls
echo ============================================================
echo   BLOCKING USB Storage Devices...
echo ============================================================
echo.

:: Disable USB Storage via Registry (Start = 4 means Disabled)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 4 /f >nul 2>&1

:: Also deny write access as an extra layer
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 4 /f

if %errorlevel% == 0 (
    color 0C
    echo  [SUCCESS] USB Storage devices are now BLOCKED.
    echo.
    echo  - Existing connected USB drives will be inaccessible.
    echo  - New USB drives will not be recognized.
    echo  - USB keyboards/mice are NOT affected.
    echo.
    echo  Registry key set:
    echo  HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR\Start = 4
) else (
    color 0E
    echo  [ERROR] Failed to block USB. Make sure you're running as Admin.
)

echo.
color 0A
pause
goto MENU


:: ============================================================
:UNBLOCK
:: ============================================================
cls
echo ============================================================
echo   UNBLOCKING USB Storage Devices...
echo ============================================================
echo.

:: Re-enable USB Storage (Start = 3 means Manual/Enabled)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 3 /f

if %errorlevel% == 0 (
    color 0A
    echo  [SUCCESS] USB Storage devices are now UNBLOCKED.
    echo.
    echo  - USB drives will be recognized normally.
    echo  - You may need to reconnect your USB device.
    echo.
    echo  Registry key set:
    echo  HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR\Start = 3
) else (
    color 0E
    echo  [ERROR] Failed to unblock USB. Make sure you're running as Admin.
)

echo.
color 0A
pause
goto MENU


:: ============================================================
:STATUS
:: ============================================================
cls
echo ============================================================
echo   CURRENT USB Storage Status
echo ============================================================
echo.

:: Read registry value
for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start 2^>nul') do set usbval=%%a

if "%usbval%"=="0x4" (
    color 0C
    echo   STATUS:  [BLOCKED]
    echo   USB Storage drives are currently DISABLED.
) else if "%usbval%"=="0x3" (
    color 0A
    echo   STATUS:  [ALLOWED]
    echo   USB Storage drives are currently ENABLED.
) else if "%usbval%"=="" (
    color 0E
    echo   STATUS:  [UNKNOWN]
    echo   Could not read registry key. USBSTOR may not exist yet.
    echo   USB is likely ALLOWED by default.
) else (
    color 0E
    echo   STATUS:  [UNKNOWN - Value: %usbval%]
)

echo.
color 0A
pause
goto MENU


:: ============================================================
:EXIT
:: ============================================================
cls
echo  Goodbye!
timeout /t 2 >nul
exit /b 0