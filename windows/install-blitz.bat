@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-blitz.ps1" %*
echo.
pause
