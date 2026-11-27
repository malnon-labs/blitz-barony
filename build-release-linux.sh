#!/bin/bash
# Assembles dist/Blitz-Barony-Linux-<version>.tar.gz: extract it INTO the Steam Barony folder, then run "BLITZ BARONY.sh".
# Contains both the native Linux exe and the Windows (Proton) exe + DLLs, so one archive works whichever depot Steam installed.
set -e
V=${1:-v0.1.8}
H=$(cd "$(dirname "$0")" && pwd); SRC=$HOME/Projects/barony-short; REL=$HOME/Games/Barony-blitz-win-release/Blitz-Barony-Windows-v0.1
OUT=$H/dist/Blitz-Barony-Linux-$V; rm -rf "$OUT"
M=$OUT/blitz-mod-linux; mkdir -p "$M/payload-common/maps" "$M/payload-common/data" "$M/payload-linux" "$M/payload-windows"
cp "$SRC/build-steam/barony" "$M/payload-linux/barony.x86_64"
cp "$SRC/build-win-steam/barony.exe" "$M/payload-windows/barony.exe"
for d in libphysfs.dll libgcc_s_seh-1.dll libstdc++-6.dll libwinpthread-1.dll; do cp "$REL/$d" "$M/payload-windows/"; done
cp "$REL/maps/"*.txt "$M/payload-common/maps/"; cp "$REL/data/gameplaymodifiers.json" "$M/payload-common/data/"
cp "$H/linux/BLITZ BARONY.sh" "$H/linux/BLITZ BARONY.desktop" "$OUT/"; chmod +x "$OUT/BLITZ BARONY.sh" "$OUT/BLITZ BARONY.desktop"
cp "$H/README.md" "$H/TESTING.md" "$M/"
(cd "$OUT" && tar --owner=0 --group=0 -czf "$H/dist/Blitz-Barony-Linux-$V.tar.gz" .)
echo "$H/dist/Blitz-Barony-Linux-$V.tar.gz"
