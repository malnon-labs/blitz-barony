@echo off
title Blitz Barony
cd /d "%~dp0"
set "msg="
:menu
cls
echo ==============================================
echo      BLITZ BARONY  -  mod manager
echo ==============================================
if exist ".blitz_on" goto st_on
echo   Status: vanilla Barony ^(mod NOT installed^)
goto st_end
:st_on
echo   Status: Blitz mod is INSTALLED
:st_end
if defined msg echo   %msg%
set "msg="
echo.
echo   [1]  Install / update the Blitz mod
echo   [2]  Restore vanilla Barony ^(undo the mod^)
echo   [3]  Collect logs ^(for a bug report^)
echo   [4]  Put a shortcut to this menu on the Desktop
echo   [Q]  Quit
echo.
choice /c 1234Q /n /m "Choose 1-4 or Q: "
if errorlevel 5 exit /b 0
if errorlevel 4 goto shortcut
if errorlevel 3 goto logs
if errorlevel 2 goto restore
if errorlevel 1 goto install
goto menu
:install
cls
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\install-blitz.ps1" -BaronyPath "%~dp0."
if errorlevel 1 goto fail
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\create-shortcut.ps1" -BaronyPath "%~dp0." >nul 2>&1
set "msg=Done - Blitz mod installed. Start Barony from Steam."
goto menu
:restore
cls
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\restore-vanilla.ps1" -BaronyPath "%~dp0."
if errorlevel 1 goto fail
set "msg=Done - vanilla Barony restored."
goto menu
:logs
cls
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\collect-logs.ps1" -BaronyPath "%~dp0."
if errorlevel 1 goto fail
set "msg=Done - blitz-logs.zip is on your Desktop."
goto menu
:shortcut
cls
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\create-shortcut.ps1" -BaronyPath "%~dp0."
if errorlevel 1 goto fail
set "msg=Done - shortcut put on your Desktop."
goto menu
:fail
echo.
echo   Something went wrong - see the message above and send a screenshot.
echo.
pause
goto menu
