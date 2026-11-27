#!/bin/bash
# Blitz Barony mod manager (Linux). Extract the tar.gz INTO your Steam Barony folder, then run this file.
# Works for the native Linux Barony (barony.x86_64) and for the Windows Barony under Proton (barony.exe).
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOD="$HERE/blitz-mod-linux"
BASE=""
msg_status=""

libraries() {
  echo "$HOME/.steam/steam"; echo "$HOME/.local/share/Steam"
  for v in "$HOME/.steam/steam/steamapps/libraryfolders.vdf" "$HOME/.local/share/Steam/steamapps/libraryfolders.vdf"; do
    [ -f "$v" ] && sed -n 's/.*"path"[[:space:]]*"\([^"]*\)".*/\1/p' "$v"
  done
}
find_base() {
  for c in "$HERE" ; do
    if [ -f "$c/barony.x86_64" ] || [ -f "$c/barony.exe" ]; then BASE="$c"; return 0; fi
  done
  while read -r l; do
    c="$l/steamapps/common/Barony"
    if [ -f "$c/barony.x86_64" ] || [ -f "$c/barony.exe" ]; then BASE="$c"; return 0; fi
  done < <(libraries)
  return 1
}
running() { pgrep -x barony.x86_64 >/dev/null || pgrep -x barony.exe >/dev/null; }
installed() { [ -f "$BASE/.blitz_on" ]; }
status_line() { if installed; then echo "Status: Blitz mod is INSTALLED"; else echo "Status: vanilla Barony (mod NOT installed)"; fi; }
pause() { echo; read -r -n1 -s -p "Press any key to continue..."; echo; }

save_dirs() {   # which savegames folders belong to the exes present
  [ -f "$BASE/barony.x86_64" ] && echo "$HOME/.barony/savegames"
  [ -f "$BASE/barony.exe" ] && echo "$BASE/savegames"
}

payload_files() {   # prints "srcfile<TAB>relative target"
  local d
  for d in common linux windows; do
    [ "$d" = linux ] && [ ! -f "$BASE/barony.x86_64" ] && continue
    [ "$d" = windows ] && [ ! -f "$BASE/barony.exe" ] && continue
    [ -d "$MOD/payload-$d" ] || continue
    ( cd "$MOD/payload-$d" && find . -type f | sed 's#^\./##' ) | while read -r rel; do
      printf '%s\t%s\n' "$MOD/payload-$d/$rel" "$rel"
    done
  done
}

do_install() {
  running && { echo "Close Barony first."; return 1; }
  [ -d "$MOD" ] || { echo "blitz-mod-linux folder not found next to this script. Extract the whole archive first."; return 1; }
  local bk="$BASE/_blitz_backup"; mkdir -p "$bk"
  touch "$bk/absent.txt"
  echo "Barony folder: $BASE"
  while IFS=$'\t' read -r src rel; do
    dst="$BASE/$rel"
    if [ -e "$dst" ]; then
      if ! cmp -s "$src" "$dst"; then            # not ours yet: it is the vanilla file, keep it as backup
        mkdir -p "$(dirname "$bk/$rel")"; cp -a "$dst" "$bk/$rel"
        grep -vxF "$rel" "$bk/absent.txt" > "$bk/absent.tmp"; mv "$bk/absent.tmp" "$bk/absent.txt"
      fi
    else
      grep -qxF "$rel" "$bk/absent.txt" || echo "$rel" >> "$bk/absent.txt"
    fi
    mkdir -p "$(dirname "$dst")"; cp -f "$src" "$dst"
    echo "  installed $rel"
  done < <(payload_files)
  [ -f "$BASE/barony.x86_64" ] && chmod +x "$BASE/barony.x86_64"
  if ! installed; then                           # keep vanilla and Blitz saves apart
    : > "$BASE/.blitz_on"
    while read -r sv; do
      echo "$sv" >> "$BASE/.blitz_on"
      [ -d "$sv" ] && mv "$sv" "$sv.vanilla"
      if [ -d "$sv.blitz" ]; then mv "$sv.blitz" "$sv"; else mkdir -p "$sv"; fi
    done < <(save_dirs)
  fi
  echo; echo "Blitz Barony installed. Start Barony from Steam as usual; the main menu should show v5.0.2-blitz."
}

do_restore() {
  running && { echo "Close Barony first."; return 1; }
  local bk="$BASE/_blitz_backup"
  [ -d "$bk" ] || { echo "No _blitz_backup here: nothing to restore."; return 1; }
  ( cd "$bk" && find . -type f ! -name absent.txt | sed 's#^\./##' ) | while read -r rel; do
    cp -a "$bk/$rel" "$BASE/$rel" && echo "  restored $rel"
  done
  while read -r rel; do
    [ -n "$rel" ] && [ -e "$BASE/$rel" ] && rm -f "$BASE/$rel" && echo "  removed $rel"
  done < "$bk/absent.txt"
  if installed; then
    while read -r sv; do
      [ -z "$sv" ] && continue
      [ -d "$sv" ] && mv "$sv" "$sv.blitz"
      if [ -d "$sv.vanilla" ]; then mv "$sv.vanilla" "$sv"; else mkdir -p "$sv"; fi
    done < "$BASE/.blitz_on"
    rm -f "$BASE/.blitz_on"
  fi
  rm -rf "$bk"
  echo; echo "Vanilla Barony restored. To install the mod again, run this menu and press 1."
}

desktop_dir() { xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop"; }

do_logs() {
  local tmp out; tmp="$(mktemp -d)"; out="$(desktop_dir)"; [ -d "$out" ] || out="$HOME"; out="$out/blitz-logs.tar.gz"
  for f in "$BASE/log.txt" "$HOME/.barony/log.txt"; do [ -f "$f" ] && cp "$f" "$tmp/$(echo "$f" | tr '/' '_')"; done
  for d in "$BASE/crashlogs" "$HOME/.barony/crashlogs"; do [ -d "$d" ] && cp -r "$d" "$tmp/$(echo "$d" | tr '/' '_')"; done
  {
    echo "date: $(date)"; echo "kernel: $(uname -a)"; echo "barony folder: $BASE"
    for e in barony.x86_64 barony.exe; do [ -f "$BASE/$e" ] && echo "$e sha256: $(sha256sum "$BASE/$e" | cut -d' ' -f1)"; done
    for f in maps/levels.txt maps/secretlevels.txt data/gameplaymodifiers.json; do
      [ -f "$BASE/$f" ] && echo "$f sha256: $(sha256sum "$BASE/$f" | cut -d' ' -f1)" || echo "$f: MISSING"
    done
    echo "blitz marker: $([ -f "$BASE/.blitz_on" ] && echo yes || echo no)"
    echo "steam running: $(pgrep -x steam >/dev/null && echo yes || echo no)"
    echo "proton logs (if any): $(ls "$HOME"/steam-371970.log 2>/dev/null)"
  } > "$tmp/info.txt"
  tar -czf "$out" -C "$tmp" . && echo "Created $out - send me this file."
  rm -rf "$tmp"
}

do_launcher() {
  local icon="$BASE/Barony_Icon256x256.png"
  [ -f "$icon" ] || icon="$(ls "$HOME"/.local/share/icons/hicolor/*/apps/steam_icon_371970.png 2>/dev/null | tail -1)"
  [ -n "$icon" ] || icon="applications-games"
  local f="$HOME/.local/share/applications/blitz-barony-manager.desktop"
  mkdir -p "$(dirname "$f")"
  cat > "$f" <<D
[Desktop Entry]
Type=Application
Name=Blitz Barony Manager
Comment=Install or remove the Blitz Barony mod
Exec=bash "$HERE/BLITZ BARONY.sh"
Path=$BASE
Icon=$icon
Terminal=true
Categories=Game;
D
  chmod +x "$f"
  local dd; dd="$(desktop_dir)"
  if [ -d "$dd" ]; then cp -f "$f" "$dd/Blitz Barony Manager.desktop"; chmod +x "$dd/Blitz Barony Manager.desktop"; gio set "$dd/Blitz Barony Manager.desktop" metadata::trusted true 2>/dev/null; fi
  echo "Launcher created (application menu: Blitz Barony Manager$([ -d "$dd" ] && echo ", and on the Desktop"))."
}

find_base || { echo "Could not find your Steam Barony folder (no barony.x86_64 or barony.exe)."; echo "Extract this archive into it, then run this script again."; pause; exit 1; }
chmod +x "$HERE/BLITZ BARONY.sh" 2>/dev/null

while true; do
  clear
  echo "=============================================="
  echo "     BLITZ BARONY  -  mod manager"
  echo "=============================================="
  echo "  $(status_line)"
  echo "  Folder: $BASE"
  echo
  echo "  [1]  Install / update the Blitz mod"
  echo "  [2]  Restore vanilla Barony (undo the mod)"
  echo "  [3]  Collect logs (for a bug report)"
  echo "  [4]  Put a launcher for this menu on the Desktop"
  echo "  [Q]  Quit"
  echo
  read -r -n1 -s -p "Choose 1-4 or Q: " c || { echo; exit 0; }; echo
  case "$c" in
    1) echo; do_install ;;
    2) echo; do_restore ;;
    3) echo; do_logs ;;
    4) echo; do_launcher ;;
    q|Q) exit 0 ;;
    *) continue ;;
  esac
  echo; echo "  Status now: $(status_line | sed 's/^Status: //')"
  pause
done
