# Puts a "Blitz Barony Manager" shortcut (with the Barony icon) on the Desktop.
param([string]$BaronyPath = "")
$ErrorActionPreference = "Stop"
$BaronyPath = [System.IO.Path]::GetFullPath($BaronyPath).TrimEnd("\")
$bat = Join-Path $BaronyPath "BLITZ BARONY.bat"
if (-not (Test-Path $bat)) { throw "BLITZ BARONY.bat not found in $BaronyPath" }
$desk = [Environment]::GetFolderPath("Desktop")
$lnk = Join-Path $desk "Blitz Barony Manager.lnk"
$ws = New-Object -ComObject WScript.Shell
$s = $ws.CreateShortcut($lnk)
$s.TargetPath = $bat
$s.WorkingDirectory = $BaronyPath
$s.IconLocation = (Join-Path $BaronyPath "barony.exe") + ",0"
$s.Description = "Install or remove the Blitz Barony mod"
$s.Save()
Write-Host "Shortcut created: $lnk"
