@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0restore-vanilla.ps1" %*
echo.
pause
