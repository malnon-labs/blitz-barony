# Restores the vanilla Barony files saved by install-blitz and removes the mod. Your vanilla saves come back; Blitz saves are kept aside.
param([string]$BaronyPath = "")
$ErrorActionPreference = "Stop"
if ($BaronyPath) { $BaronyPath = [System.IO.Path]::GetFullPath($BaronyPath).TrimEnd("\") }
function Find-Barony {
    $libs = @()
    $steam = (Get-ItemProperty "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue).SteamPath
    if ($steam) {
        $libs += $steam
        $vdf = Join-Path $steam "steamapps\libraryfolders.vdf"
        if (Test-Path $vdf) { foreach ($m in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) { $libs += $m.Groups[1].Value.Replace("\\", "\") } }
    }
    foreach ($l in $libs) { $p = Join-Path $l "steamapps\common\Barony"; if (Test-Path (Join-Path $p "_blitz_backup")) { return $p } }
    return $null
}
if (-not $BaronyPath -or -not (Test-Path (Join-Path $BaronyPath "_blitz_backup"))) { $BaronyPath = Find-Barony }
if (-not $BaronyPath) { $BaronyPath = Read-Host "Paste the Barony folder that contains _blitz_backup" }
$backup = Join-Path $BaronyPath "_blitz_backup"
if (-not (Test-Path $backup)) { throw "No _blitz_backup in '$BaronyPath': nothing to restore (or the mod was never installed there)." }
if (Get-Process -Name "barony" -ErrorAction SilentlyContinue) { throw "Close Barony first." }

foreach ($f in Get-ChildItem $backup -Recurse -File) {
    if ($f.Name -eq "absent.txt") { continue }
    $rel = $f.FullName.Substring($backup.Length).TrimStart("\", "/")
    Copy-Item $f.FullName (Join-Path $BaronyPath $rel) -Force
    Write-Host "  restored $rel"
}
$absentFile = Join-Path $backup "absent.txt"
if (Test-Path $absentFile) {
    foreach ($rel in Get-Content $absentFile) {
        if ($rel) { $p = Join-Path $BaronyPath $rel; if (Test-Path $p) { Remove-Item $p -Force; Write-Host "  removed $rel" } }
    }
}
$marker = Join-Path $BaronyPath ".blitz_on"
if (Test-Path $marker) {
    $sv = Join-Path $BaronyPath "savegames"; $sk = Join-Path $BaronyPath "savegames.vanilla"
    if (Test-Path $sv) { Rename-Item $sv "savegames.blitz" }
    if (Test-Path $sk) { Rename-Item $sk "savegames" } else { New-Item -ItemType Directory $sv | Out-Null }
    Remove-Item $marker -Force
}
Remove-Item $backup -Recurse -Force
Write-Host ""
Write-Host "Vanilla Barony restored. (Tip: Steam > Barony > Properties > Installed Files > Verify also works.)"
