@echo off
setlocal
set "BB_HUNTERS_DREAM=1"

if not exist "%~dp0Bloodborne.exe" (
    echo Bloodborne.exe was not found next to this script.
    echo Copy this .bat into the bbport folder, beside Bloodborne.exe.
    pause
    exit /b 1
)

start "" "%~dp0Bloodborne.exe" %*
