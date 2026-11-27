# Blitz Barony

A shorter Barony (v5.0.2 base): 2-3 floors per biome instead of 4, with XP, skill gain and gold scaled so the power curve stays similar, and every secret level kept (Gnomish Mines, Minetown, Underworld, Temple, Haunted Castle, Sokoban, Minotaur Maze, Mystic Library, Cave Lair, Bram, Baphomet, Hamlet). A full run should take roughly half the time.

**Status: private test build.** Windows with Steam. The online lobby (Steam) is the part being tested right now.

## What changes
- 24 floors instead of ~35; monsters and loot scale as if each floor were the vanilla depth it stands in for.
- XP x1.0-2.5 by depth, skill gain x1.9, gold on generated floors x1.9, shops on ~60% of floors, minotaurs ~49% on eligible floors.
- Game version string is `v5.0.2-blitz`, so vanilla clients cannot join modded lobbies and vice versa. Everyone in a game needs the same install.
- Steam achievements are disabled by modded game files.

## Install (Windows, Steam copy of Barony)
1. In Steam: right-click Barony > Manage > **Browse local files**. This opens the Barony game folder (the one with `barony.exe`).
2. Download `Blitz-Barony-Windows-<version>.zip` from the **Releases** page of this repo.
3. Extract the zip **into that Barony folder** (right-click the zip > Extract All, and set the destination to the Barony folder, or open the zip and drag everything in). Allow overwriting if asked. You'll see `INSTALL BLITZ MOD.bat`, `RESTORE VANILLA.bat`, `COLLECT LOGS.bat` and a `blitz-mod` folder next to `barony.exe`.
4. Close Barony, then double-click **`INSTALL BLITZ MOD.bat`**.
   - It copies every file it replaces to `_blitz_backup\`, installs the mod, and keeps your vanilla saves separate from Blitz saves.
   - Running it again is safe (for example after a Steam update).
5. Start Barony from Steam as usual. The main menu should say **v5.0.2-blitz**.

## Go back to vanilla
Double-click **`RESTORE VANILLA.bat`** in the same folder (close Barony first). It puts every original file back, removes the mod's files, and gives you your vanilla saves again. Steam's "Verify integrity of game files" also restores vanilla, and you can double-click the installer again afterwards.

## What gets installed
`barony.exe` (modified build with Steam support), `libphysfs.dll`, `libgcc_s_seh-1.dll`, `libstdc++-6.dll`, `libwinpthread-1.dll`, `maps\levels.txt`, `maps\secretlevels.txt`, `data\gameplaymodifiers.json`. No game assets are included; you need your own copy of Barony.

## Testing and reporting
See [TESTING.md](TESTING.md).

## Credits / license
Barony is by Turning Wheel and its source is BSD-2-Clause; this is an unofficial modified build, not affiliated with or endorsed by them. Barony game assets are not distributed here.
