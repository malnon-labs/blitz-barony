@echo off
title Collect Blitz Barony logs
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\collect-logs.ps1" -BaronyPath "%~dp0."
if errorlevel 1 echo. & echo Something went wrong - see the message above, and send me a screenshot.
echo.
pause
