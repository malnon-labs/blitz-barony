#!/bin/bash
# Assembles dist/Blitz-Barony-Windows-<version>.zip from the build in ~/Projects/barony-short (not committed: binaries go in GitHub Releases).
set -e
V=${1:-v0.1.1}
H=$(cd "$(dirname "$0")" && pwd); SRC=$HOME/Projects/barony-short; REL=$HOME/Games/Barony-blitz-win-release/Blitz-Barony-Windows-v0.1
OUT=$H/dist/Blitz-Barony-Windows-$V; rm -rf "$OUT"; mkdir -p "$OUT/payload/maps" "$OUT/payload/data"
cp "$SRC/build-win-steam/barony.exe" "$OUT/payload/barony.exe"
for d in libphysfs.dll libgcc_s_seh-1.dll libstdc++-6.dll libwinpthread-1.dll; do cp "$REL/$d" "$OUT/payload/"; done
cp "$SRC/mod/levels.txt" "$SRC/mod/secretlevels.txt" "$OUT/payload/maps/" 2>/dev/null || cp "$REL/maps/"*.txt "$OUT/payload/maps/"
cp "$SRC/mod/data/gameplaymodifiers.json" "$OUT/payload/data/" 2>/dev/null || cp "$REL/data/gameplaymodifiers.json" "$OUT/payload/data/"
cp "$H"/windows/* "$H/README.md" "$H/TESTING.md" "$OUT/"
(cd "$H/dist" && rm -f "Blitz-Barony-Windows-$V.zip" && zip -qr "Blitz-Barony-Windows-$V.zip" "Blitz-Barony-Windows-$V")
echo "$H/dist/Blitz-Barony-Windows-$V.zip"
