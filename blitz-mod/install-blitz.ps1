# Blitz Barony installer (Windows). Backs up every file it replaces, then installs the mod into your Steam Barony folder.
# Undo with restore-vanilla.bat. Safe to run again (e.g. after a Steam update or "Verify integrity").
param([string]$BaronyPath = "", [string]$Preset = "all")
$ErrorActionPreference = "Stop"
if ($BaronyPath) { $BaronyPath = [System.IO.Path]::GetFullPath($BaronyPath).TrimEnd("\") }
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$payload = Join-Path $here "payload"
if (-not (Test-Path $payload)) { throw "payload folder not found next to this script. Extract the whole zip first." }

# Presets: all = Blitz + rebalanced stations + adaptive XP | blitz = Blitz only | stations = Blitz + rebalanced stations | xp = Blitz + adaptive XP
$presets = @{
    all      = @{ adaptive_xp = 1; stations = $true }
    blitz    = @{ adaptive_xp = 0; stations = $false }
    stations = @{ adaptive_xp = 0; stations = $true }
    xp       = @{ adaptive_xp = 1; stations = $false }
}
if (-not $presets.ContainsKey($Preset)) { throw "Unknown preset '$Preset' (use all, blitz, stations or xp)." }

# Sets "key = value" in blitz.cfg and keeps the comment after it
function Set-Cfg([string]$file, [string]$key, $value) {
    $text = [System.IO.File]::ReadAllText($file)
    $new = [regex]::Replace($text, "(?m)^(" + [regex]::Escape($key) + "\s*=\s*)[^\s#]+", ('${1}' + $value))
    [System.IO.File]::WriteAllText($file, $new)
}

function Find-Barony {
    $libs = @()
    $steam = (Get-ItemProperty "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue).SteamPath
    if (-not $steam) { $steam = (Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam" -ErrorAction SilentlyContinue).InstallPath }
    if ($steam) {
        $libs += $steam
        $vdf = Join-Path $steam "steamapps\libraryfolders.vdf"
        if (Test-Path $vdf) {
            foreach ($m in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) { $libs += $m.Groups[1].Value.Replace("\\", "\") }
        }
    }
    foreach ($l in $libs) {
        $p = Join-Path $l "steamapps\common\Barony"
        if (Test-Path (Join-Path $p "barony.exe")) { return $p }
    }
    return $null
}

if (-not $BaronyPath -or -not (Test-Path (Join-Path $BaronyPath "barony.exe"))) {
    if ($BaronyPath) { Write-Host "barony.exe not found in $BaronyPath - looking for your Steam copy of Barony..." }
    $BaronyPath = Find-Barony
}
if (-not $BaronyPath -or -not (Test-Path (Join-Path $BaronyPath "barony.exe"))) {
    $BaronyPath = Read-Host "Could not find Barony automatically. Paste the folder that contains barony.exe"
}
if (-not (Test-Path (Join-Path $BaronyPath "barony.exe"))) { throw "barony.exe not found in '$BaronyPath'" }
if (Get-Process -Name "barony" -ErrorAction SilentlyContinue) { throw "Close Barony first." }

Write-Host "Barony folder: $BaronyPath"
$backup = Join-Path $BaronyPath "_blitz_backup"
New-Item -ItemType Directory -Force $backup | Out-Null
$absentFile = Join-Path $backup "absent.txt"
$absent = @(); if (Test-Path $absentFile) { $absent = @(Get-Content $absentFile | Where-Object { $_ }) }

$alreadyOn = Test-Path (Join-Path $BaronyPath ".blitz_on")   # updating: files in the game folder may already be ours, so never overwrite the vanilla backup
$files = Get-ChildItem $payload -Recurse -File
foreach ($f in $files) {
    $rel = $f.FullName.Substring($payload.Length).TrimStart("\", "/")
    $dst = Join-Path $BaronyPath $rel
    $bak = Join-Path $backup $rel
    if ($rel -ieq "data\blitz.cfg" -and $alreadyOn -and (Test-Path $dst)) { Write-Host "  kept your existing data\blitz.cfg"; continue }   # never overwrite the player's settings on update
    if (Test-Path $dst) {
        $same = (Get-FileHash $dst).Hash -eq (Get-FileHash $f.FullName).Hash
        if (-not $same -and -not ($alreadyOn -and (Test-Path $bak))) {   # current file is not ours yet: it is vanilla (or a fresh Steam copy), so keep it as the backup
            New-Item -ItemType Directory -Force (Split-Path $bak) | Out-Null
            Copy-Item $dst $bak -Force
            $absent = @($absent | Where-Object { $_ -ne $rel })
        }
    } else {
        if ($absent -notcontains $rel) { $absent += $rel }
    }
    New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
    Copy-Item $f.FullName $dst -Force
    Write-Host "  installed $rel"
}
Set-Content $absentFile @($absent)

# apply the chosen preset to data\blitz.cfg
$cfg = Join-Path $BaronyPath "data\blitz.cfg"
if (Test-Path $cfg) {
    $pr = $presets[$Preset]
    Set-Cfg $cfg "adaptive_xp" $pr.adaptive_xp
    if ($pr.stations) {
        Set-Cfg $cfg "station_transition_percent" 50; Set-Cfg $cfg "station_workbench_last_floor_percent" 50; Set-Cfg $cfg "station_biome_percent" 33
        Set-Cfg $cfg "station_hamlet_cauldron" 1; Set-Cfg $cfg "station_hamlet_workbench" 1
    } else {
        Set-Cfg $cfg "station_transition_percent" 0; Set-Cfg $cfg "station_workbench_last_floor_percent" 0; Set-Cfg $cfg "station_biome_percent" 100
        Set-Cfg $cfg "station_hamlet_cauldron" 0; Set-Cfg $cfg "station_hamlet_workbench" 0
    }
    Write-Host "  preset '$Preset' applied to data\blitz.cfg"
}

# keep vanilla and Blitz saves apart
$marker = Join-Path $BaronyPath ".blitz_on"
if (-not (Test-Path $marker)) {
    $sv = Join-Path $BaronyPath "savegames"; $sb = Join-Path $BaronyPath "savegames.blitz"; $sk = Join-Path $BaronyPath "savegames.vanilla"
    if (Test-Path $sv) { Rename-Item $sv "savegames.vanilla" }
    if (Test-Path $sb) { Rename-Item $sb "savegames" } else { New-Item -ItemType Directory $sv | Out-Null }
    New-Item -ItemType File $marker | Out-Null
}
Write-Host ""
Write-Host "Blitz Barony installed. Start Barony from Steam as usual; the main menu should show version v5.0.2-blitz."
Write-Host "Preset: $Preset.  Fine tuning: edit data\blitz.cfg in the Barony folder (one setting per line, with comments)."
Write-Host "To go back to vanilla, open BLITZ BARONY.bat and choose Restore."
