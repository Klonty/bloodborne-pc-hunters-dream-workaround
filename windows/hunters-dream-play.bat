@echo off
setlocal
set "BB_HUNTERS_DREAM=1"

if not exist "%~dp0Play Bloodborne.exe" (
    echo Play Bloodborne.exe was not found next to this script.
    echo Copy this .bat into the bbport folder, beside Play Bloodborne.exe.
    pause
    exit /b 1
)

start "" "%~dp0Play Bloodborne.exe" %*
