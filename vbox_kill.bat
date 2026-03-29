@echo off
echo Searching for VirtualBox-related processes...
echo =============================================

:: Search for VirtualBox-related processes
tasklist | findstr /i "virtual vbox"

:: Ask user if they want to terminate any process
echo.
set /p choice="Do you want to kill these processes? (y/n): "

if /i "%choice%"=="y" (
    echo Killing VirtualBox-related processes...
    for %%P in (VirtualBox.exe VBoxSVC.exe VBoxSDS.exe VBoxHeadless.exe VBoxNetDHCP.exe VBoxNetAdpCpl.exe) do (
        taskkill /IM %%P /F 2>nul
    )
    echo All found processes have been terminated.
) else (
    echo No processes were terminated.
)

echo Done.
pause
