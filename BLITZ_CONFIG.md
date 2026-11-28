# Blitz Barony settings (`data/blitz.cfg`)

All Blitz settings are in **one plain text file**: `data/blitz.cfg`, inside your Barony game folder.

```
station_transition_percent = 50   # chance of a cooking pot in the chest room of each transition floor
adaptive_xp = 1                   # 1 = on, 0 = off
```

- One setting per line: `name = value`. Everything after a `#` is a comment.
- Save the file and enter a new floor. The game re-reads it on every floor load, so you do not need to restart.
- Percent settings: `0` = never, `100` = always.
- A mistyped name is ignored and reported in `log.txt` as `[CFG]: Unknown key`. A line `[CFG]: blitz.cfg applied (18 settings)` shows the file was read.
- `blitz.cfg` overrides the same settings in `data/gameplaymodifiers.json`. Edit only `blitz.cfg`. The floor lists (which floors may have shops, minotaurs and so on) stay in the JSON.
- The installer menu keeps your edits when you update. Its install options only change the adaptive XP and station lines (see below).
- Make a copy before experimenting. Deleting the file makes the game fall back to the JSON values.

A station roll depends on the map seed: re-entering the same floor in the same game gives the same result. Start a new game, or set a percent to 100, to test.

## Experience
| setting | default | meaning |
|---|---|---|
| `xp_curve` | `1:100, 5:105, 8:150, 10:190, 26:220, 35:250` | XP multiplier in percent by depth, as `depth:percent`. Depth is the vanilla-equivalent floor (1-35), with straight lines between points |
| `gold_percent` | 180 | gold from monsters and generated floors (100 = vanilla) |
| `skill_gain_percent` | 190 | skill training speed (100 = vanilla) |

## Adaptive XP (catch-up and anti-grinding)
Every player's XP is multiplied again by a factor that depends on how their level compares to the **target level** for the current depth. Behind the target gives a bonus, on target is x1.0, ahead gives a penalty that never reaches zero. It is worked out per player, and it multiplies with the XP curve above.

| setting | default | meaning |
|---|---|---|
| `adaptive_xp` | 1 | 1 = on, 0 = off |
| `adaptive_target_curve` | `1:1, 2:3, 4:8, 7:12, 10:18, 14:24, 17:29, 20:34, 26:43, 30:50, 35:60` | target player level by depth, as `depth:level` |
| `adaptive_behind_levels` | 15 | this many levels below the target gives the full bonus |
| `adaptive_behind_max_percent` | 200 | XP at that point (200 = double, 100 = no bonus) |
| `adaptive_ahead_levels` | 15 | this many levels above the target gives the full penalty |
| `adaptive_ahead_min_percent` | 40 | XP at that point (40 = 40%; 100 = no penalty) |

Example at depth 12 (target level 21): level 1 gets x2.0, level 14 about x1.47, level 21 gets x1.0, level 28 about x0.7 and level 36 or higher gets x0.4.

## Stations (cooking pot and workbench)
| setting | default | meaning |
|---|---|---|
| `station_transition_percent` | 50 | chance of a cooking pot in the small chest room of each of the 4 transition floors (mines to swamp, swamp to labyrinth, labyrinth to ruins, caves to citadel) |
| `station_workbench_last_floor_percent` | 50 | chance of a workbench in the arrival room of the last generated floor of each biome |
| `station_biome_percent` | 33 | chance, per biome, of one extra random station (pot or workbench) on a normal floor. 100 = one guaranteed per biome, as in the first Blitz versions |
| `station_hamlet_cauldron` | 1 | 1 = a cooking pot in the Hamlet food shop, 0 = none |
| `station_hamlet_workbench` | 1 | 1 = a workbench in the Hamlet weapon shop, 0 = none |

## Floor events (apply to every biome)
| setting | default | meaning |
|---|---|---|
| `minotaur_percent` | 49 | chance that a minotaur can arrive on a floor that allows one |
| `shop_percent` | 60 | chance that a floor that allows shops has one |
| `dark_percent` | 25 | chance that a floor that allows darkness is dark |
| `npc_percent` | 10 | chance that a floor that allows a friendly NPC has one |

## Installer presets
The installer menu sets these lines for you:

| menu option | `adaptive_xp` | stations |
|---|---|---|
| 1 All | 1 | rebalanced (50 / 50 / 33, Hamlet 1 / 1) |
| 2 Blitz only | 0 | original (0 / 0 / 100, Hamlet 0 / 0) |
| 3 Blitz + rebalanced stations | 0 | rebalanced |
| 4 Blitz + adaptive XP | 1 | original |

You can also pick the values yourself afterwards.

## Not configurable
The 24-floor layout, which floor holds which secret, and the vanilla-depth table are part of the mod's program.

## Tuning with the log
`log.txt` shows what happened: `[XP] adaptive:` (your level, the target and the factor on each kill), `[LEVELUP]`, `[FLOOR]` (one block per floor), `[STATION]` (where a station was placed or why not), `[SHOP]`, `[MINOTAUR]` and `[CFG]`.
