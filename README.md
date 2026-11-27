# Blitz Barony

A shorter [Barony](https://store.steampowered.com/app/371970/Barony/) (v5.0.2). A full run has about **half as many floors** (24 instead of ~35), so a co-op run that normally takes around five hours should fit in roughly half the time. Every secret level is still in the game.

Experience, skill gain, gold, loot, shops and minotaurs have all been adjusted so the game balance stays the same as vanilla, even though there are fewer floors. You should reach about the same power level at the same point of the story. The exact changes are listed at the [bottom of this page](#detailed-changes).

> **Status: private test build.** It is an unofficial mod and is not affiliated with Turning Wheel. You need your own copy of Barony from Steam. No game assets are included.

## Install

The installer is a small menu that backs up every file it replaces, installs the mod, and can put vanilla back at any time. Your vanilla saves and your Blitz saves are kept apart.

### Windows (Steam)

1. In Steam, right-click Barony, choose **Manage**, then **Browse local files**. This opens the game folder (the one with `barony.exe`).
2. Download `Blitz-Barony-Windows-<version>.zip` from the **Releases** page and extract it **into that folder**. Allow overwriting if asked. You get a `BLITZ BARONY.bat` and a `blitz-mod` folder next to `barony.exe`.
3. Close Barony and double-click **`BLITZ BARONY.bat`**. Press **1** to install.
4. Start Barony from Steam. The main menu should show **v5.0.2-blitz**.

The menu also has **2** (restore vanilla), **3** (collect logs for a bug report) and **4** (put a shortcut with the Barony icon on your Desktop).

### Linux (Steam)

Works for the native Linux Barony and for the Windows Barony under Proton.

1. In Steam: Barony > Manage > **Browse local files**.
2. Extract `Blitz-Barony-Linux-<version>.tar.gz` into that folder:
   `tar xzf Blitz-Barony-Linux-<version>.tar.gz -C <that folder>`
3. Close Barony. In a terminal, `cd` into the game folder and run:
   `bash "BLITZ BARONY.sh"`
   (Double-clicking it does nothing in some file managers, such as KDE Dolphin.)
4. Press **1** to install, then start Barony from Steam. The main menu should show **v5.0.2-blitz**.

<p align="center">
  <img src="docs/linux-install.png" alt="Blitz Barony menu in a Linux terminal, after pressing 1 to install" width="70%">
</p>

### Going back to vanilla

Open the same menu and press **2**. Every original file is put back, the mod's files are removed, and your vanilla saves return. Steam's "Verify integrity of game files" also restores vanilla. You can install again afterwards.

## Multiplayer

- Everyone in a game needs the **same install**. The game version is `v5.0.2-blitz`, so vanilla clients cannot join a Blitz lobby, and the other way round.
- Steam lobbies work. Hosting an online lobby has been tested on Windows 11 and on Linux (Proton). A second player joining has not been tested yet.
- Steam achievements are disabled while the mod is installed.
- Saves from vanilla do not carry over. Start a new game.

## Reporting a problem

Use menu option **3** (Collect logs) right after the problem, before starting Barony again, and send the file it creates. See [TESTING.md](TESTING.md) for a short test checklist and a report template.

## Credits and license

Barony is made by Turning Wheel, and its source code is released under the BSD 2-Clause license. This mod is a modified build of that source. Barony's game files, art and sound are **not** included here; the installer only adds the modified executable, a few libraries it needs, and three small data files.

---

## Detailed changes

### Floors

The run has 24 floors after the start map. "Vanilla depth" is the depth of the vanilla floor whose difficulty each Blitz floor uses: monsters, loot and item levels are generated as if you were that deep.

| Biome | Blitz floors | Number of floors | Vanilla depth |
|---|---|---|---|
| Start | 0 | 1 | 0 |
| The Mines | 1 - 3 | 3 | 2, 3, 4 |
| Mines to Swamp transition | 4 | 1 | 5 |
| The Swamp | 5 - 7 | 3 | 7, 8, 9 |
| Swamp to Labyrinth transition | 8 | 1 | 10 |
| The Labyrinth | 9 - 10 | 2 | 12, 14 |
| Labyrinth to Ruins transition | 11 | 1 | 15 |
| The Ruins | 12 - 13 | 2 | 17, 19 |
| Herx (boss) | 14 | 1 | 20 |
| Hell | 15 - 16 | 2 | 22, 23 |
| Baphomet (boss) | 17 | 1 | 24 |
| Hamlet | 18 | 1 | 25 |
| The Caves | 19 - 20 | 2 | 26, 29 |
| Caves to Citadel transition | 21 | 1 | 30 |
| The Citadel | 22 - 23 | 2 | 32, 34 |
| Sanctum (final) | 24 | 1 | 35 |

The three orbs are on the last floor of the Swamp (green, floor 7), the Labyrinth (red, floor 10) and the Ruins (blue, floor 13).

### Secret levels

All secrets are kept. The "entry floor" is the floor that contains the way in.

| Secret | Entry floor | Chance |
|---|---|---|
| Gnomish Mines | 2 (Mines) | 100% |
| Minetown | 3 (Mines) | 50% |
| Underworld, first pair of sections | 4 (Mines to Swamp transition) | 100% |
| Temple | 6 (Swamp) | 100% |
| Haunted Castle | 7 (Swamp) | 100% |
| Sokoban | 9 (Labyrinth) | 100% |
| Minotaur Maze | 10 (Labyrinth) | 100% |
| Mystic Library | 12 (Ruins) | 100% |
| Underworld, second pair of sections | 13 (Ruins) | 100% |
| Baphomet portal (leads to the Baphomet fight) | 16 (Hell) | 100% |
| Cave Lair | 20 (Caves) | 100% |
| Bram's Castle | 23 (Citadel) | 100% |

Floors 1, 5, 19 and 22 (the first floor of the Mines, Swamp, Caves and Citadel) have no secret. Leaving the first Underworld returns you to the Swamp; the exits of the second Underworld lead on to Herx or to Hell.

### Experience, skills and gold

- **Experience** is multiplied by a value that grows with depth, so early floors give about the vanilla amount and later floors give more to make up for the floors that are gone. The curve is interpolated linearly between these points:

  | Vanilla depth | 1 | 5 | 8 | 10 | 26 | 35 |
  |---|---|---|---|---|---|---|
  | XP multiplier | 100% | 105% | 150% | 190% | 220% | 250% |

  Per Blitz floor that works out to:

  | Floor | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
  |---|---|---|---|---|---|---|---|---|---|---|---|---|
  | XP | 101% | 103% | 104% | 105% | 135% | 150% | 170% | 190% | 194% | 198% | 199% | 203% |

  | Floor | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 |
  |---|---|---|---|---|---|---|---|---|---|---|---|---|
  | XP | 207% | 209% | 213% | 214% | 216% | 218% | 220% | 230% | 233% | 240% | 247% | 250% |

- **Skill gain** is multiplied by 190% everywhere.
- **Gold** is multiplied by 190% on the randomly generated floors (floor piles, pots and monster drops). The fixed secret maps keep their vanilla amounts. By design the total over a run is close to the vanilla main route.
- Monster levels, loot and item generation use the vanilla depth column above, not the floor number.
- Hunger and regeneration are per-time mechanics and were left alone.

### Shops

Shops can appear on 13 eligible floors. Each eligible floor rolls **60%** independently. Hell never has a shop.

| Biome | Eligible floors | Expected shops |
|---|---|---|
| The Mines | 2, 3 | 1.2 |
| The Swamp | 5, 6, 7 | 1.8 |
| The Labyrinth | 9, 10 | 1.2 |
| The Ruins | 12, 13 | 1.2 |
| Hell | none | 0 |
| The Caves | 19, 20 | 1.2 |
| The Citadel | 22, 23 | 1.2 |
| **Whole run** | 13 floors | **7.8** |

Number of shops in a full run (calculated from the 60% rolls):

| Shops | 3 or fewer | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 or more |
|---|---|---|---|---|---|---|---|---|---|---|
| Chance | 0.7% | 2.4% | 6.6% | 13.1% | 19.7% | 22.1% | 18.4% | 11.1% | 4.5% | 1.2% |

Two test runs (26 eligible floors in total) produced 16 shops, which is 61.5% and matches the setting.

### Minotaurs

Minotaurs can arrive on 8 eligible floors, never on the first floor of a biome. Each eligible floor rolls **49%** independently. The time before a minotaur shows up is also about 67% longer than in vanilla (5/3 of the vanilla timer). The last section of the first Underworld keeps its minotaur rule as in vanilla.

| Biome | Eligible floors | Expected minotaurs |
|---|---|---|
| The Mines | 2, 3 | 0.98 |
| The Swamp | 6, 7 | 0.98 |
| The Labyrinth | 10 | 0.49 |
| The Ruins | 13 | 0.49 |
| Hell | none | 0 |
| The Caves | 20 | 0.49 |
| The Citadel | 23 | 0.49 |
| **Whole run** | 8 floors | **3.9** |

Number of minotaur floors in a full run (calculated from the 49% rolls):

| Minotaurs | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 or more |
|---|---|---|---|---|---|---|---|---|
| Chance | 0.5% | 3.5% | 11.8% | 22.7% | 27.3% | 21.0% | 10.1% | 3.1% |

### Other

- The version string is `v5.0.2-blitz`. Internally the multiplayer join packet carries a short `v5.0.2b` marker, because the packet only has room for 8 characters.
- The cheat console still works after `/enablecheats`. `/gotolevel <n>` jumps to a floor from 1 to 24.
- The installer touches only these files: `barony.exe` (or `barony.x86_64`), four runtime DLLs on Windows, `maps/levels.txt`, `maps/secretlevels.txt` and `data/gameplaymodifiers.json`. Originals are copied to `_blitz_backup` in the game folder first.
