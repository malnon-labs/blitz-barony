@echo off
title Blitz Barony
cd /d "%~dp0"
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
echo.
echo   [1]  Install / update: ALL ^(Blitz + rebalanced stations + adaptive XP^)
echo   [2]  Install / update: Blitz only
echo   [3]  Install / update: Blitz + rebalanced stations
echo   [4]  Install / update: Blitz + adaptive XP
echo   [5]  Restore vanilla Barony ^(undo the mod^)
echo   [6]  Collect logs ^(for a bug report^)
echo   [7]  Put a shortcut to this menu on the Desktop
echo   [Q]  Quit
echo.
echo   Fine tuning: open data\blitz.cfg in the Barony folder ^(one setting per line, with comments^).
echo.
choice /c 1234567Q /n /m "Choose 1-7 or Q: "
if errorlevel 8 exit /b 0
if errorlevel 7 goto shortcut
if errorlevel 6 goto logs
if errorlevel 5 goto restore
if errorlevel 4 set PRESET=xp& goto install
if errorlevel 3 set PRESET=stations& goto install
if errorlevel 2 set PRESET=blitz& goto install
if errorlevel 1 set PRESET=all& goto install
goto menu
:install
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\install-blitz.ps1" -BaronyPath "%~dp0." -Preset %PRESET%
if errorlevel 1 goto fail
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\create-shortcut.ps1" -BaronyPath "%~dp0." >nul 2>&1
goto done
:restore
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\restore-vanilla.ps1" -BaronyPath "%~dp0."
if errorlevel 1 goto fail
goto done
:logs
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\collect-logs.ps1" -BaronyPath "%~dp0."
if errorlevel 1 goto fail
goto done
:shortcut
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blitz-mod\create-shortcut.ps1" -BaronyPath "%~dp0."
if errorlevel 1 goto fail
goto done
:fail
echo.
echo   Something went wrong - see the message above and send a screenshot.
:done
echo.
call :showstatus
echo.
pause
goto menu
:showstatus
if exist ".blitz_on" goto ss_on
echo   Status now: vanilla Barony ^(mod NOT installed^)
exit /b
:ss_on
echo   Status now: Blitz mod is INSTALLED
exit /b
