# Gathers what is needed to debug a Blitz Barony problem into one zip on your Desktop. Nothing is uploaded.
param([string]$BaronyPath = "")
$ErrorActionPreference = "Continue"
if ($BaronyPath) { $BaronyPath = [System.IO.Path]::GetFullPath($BaronyPath).TrimEnd("\") }
if (-not $BaronyPath -or -not (Test-Path (Join-Path $BaronyPath "barony.exe"))) {
    $steam = (Get-ItemProperty "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue).SteamPath
    $cands = @(); if ($steam) { $cands += (Join-Path $steam "steamapps\common\Barony"); foreach ($m in [regex]::Matches((Get-Content (Join-Path $steam "steamapps\libraryfolders.vdf") -Raw -ErrorAction SilentlyContinue), '"path"\s+"([^"]+)"')) { $cands += (Join-Path $m.Groups[1].Value.Replace("\\", "\") "steamapps\common\Barony") } }
    foreach ($c in $cands) { if (Test-Path (Join-Path $c "barony.exe")) { $BaronyPath = $c; break } }
}
if (-not $BaronyPath) { $BaronyPath = Read-Host "Paste the Barony folder" }
$tmp = Join-Path $env:TEMP ("blitz-logs-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
New-Item -ItemType Directory $tmp | Out-Null
foreach ($n in "log.txt", "stdout.txt", "stderr.txt") { $p = Join-Path $BaronyPath $n; if (Test-Path $p) { Copy-Item $p $tmp } }
$cl = Join-Path $BaronyPath "crashlogs"; if (Test-Path $cl) { Copy-Item $cl (Join-Path $tmp "crashlogs") -Recurse }
$info = @()
$info += "date: " + (Get-Date)
$info += "windows: " + [System.Environment]::OSVersion.VersionString
$info += "barony folder: $BaronyPath"
$exe = Join-Path $BaronyPath "barony.exe"; if (Test-Path $exe) { $info += "barony.exe sha256: " + (Get-FileHash $exe).Hash; $info += "barony.exe size: " + (Get-Item $exe).Length }
$info += "blitz installed marker: " + (Test-Path (Join-Path $BaronyPath ".blitz_on"))
foreach ($n in "maps\levels.txt", "maps\secretlevels.txt", "data\gameplaymodifiers.json", "steam_api64.dll", "fmod.dll") { $p = Join-Path $BaronyPath $n; if (Test-Path $p) { $info += "$n sha256: " + (Get-FileHash $p).Hash } else { $info += "${n}: MISSING" } }
$info += "steam running: " + [bool](Get-Process -Name steam -ErrorAction SilentlyContinue)
$info | Set-Content (Join-Path $tmp "info.txt")
$zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "blitz-logs.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $tmp "*") -DestinationPath $zip
Write-Host "Created $zip - send me this file."
