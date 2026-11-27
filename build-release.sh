#!/bin/bash
# Assembles dist/Blitz-Barony-Windows-<version>.zip from the build in ~/Projects/barony-short (not committed: binaries go in GitHub Releases).
set -e
V=${1:-v0.1.1}
H=$(cd "$(dirname "$0")" && pwd); SRC=$HOME/Projects/barony-short; REL=$HOME/Games/Barony-blitz-win-release/Blitz-Barony-Windows-v0.1
OUT=$H/dist/Blitz-Barony-Windows-$V; rm -rf "$OUT"; mkdir -p "$OUT/blitz-mod/payload/maps" "$OUT/blitz-mod/payload/data"
cp "$SRC/build-win-steam/barony.exe" "$OUT/blitz-mod/payload/barony.exe"
python3 "$H/sanitize.py" "$OUT/blitz-mod/payload/barony.exe"
for d in libphysfs.dll libgcc_s_seh-1.dll libstdc++-6.dll libwinpthread-1.dll; do cp "$REL/$d" "$OUT/blitz-mod/payload/"; done
cp "$SRC/mod/levels.txt" "$SRC/mod/secretlevels.txt" "$OUT/blitz-mod/payload/maps/" 2>/dev/null || cp "$REL/maps/"*.txt "$OUT/blitz-mod/payload/maps/"
cp "$SRC/mod/data/gameplaymodifiers.json" "$OUT/blitz-mod/payload/data/" 2>/dev/null || cp "$REL/data/gameplaymodifiers.json" "$OUT/blitz-mod/payload/data/"
cp "$H"/blitz-mod/*.ps1 "$H/README.md" "$H/TESTING.md" "$OUT/blitz-mod/"
cp "$H/BLITZ BARONY.bat" "$OUT/"
# flat zip: extract it straight INTO the Barony game folder
(cd "$OUT" && rm -f "$H/dist/Blitz-Barony-Windows-$V.zip" && zip -qr "$H/dist/Blitz-Barony-Windows-$V.zip" .)
echo "$H/dist/Blitz-Barony-Windows-$V.zip"
