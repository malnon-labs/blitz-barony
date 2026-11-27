# Testing Blitz Barony

Thanks for testing. The main question right now: **does hosting and joining an online (Steam) lobby work without crashing?** Earlier builds crashed or refused to start because of mismatched Steam interface versions; v0.1.2 hosts a lobby fine on a Windows 11 test PC (solo host).

## Before you start
1. Install as described in blitz-mod\README.md (extract the zip into the Barony folder, double-click BLITZ BARONY.bat and press 1). Check the main menu shows `v5.0.2-blitz`.
2. Steam must be running and you must be logged in (online lobbies need it).
3. If anything goes wrong, open the **BLITZ BARONY** menu and press **3** (Collect logs) right afterwards (before relaunching the game: `log.txt` is overwritten on each start). It creates `blitz-logs.zip` on your Desktop. Send me that file.

## Test checklist (note PASS / FAIL for each)
| # | Test | Expected |
|---|------|----------|
| 1 | Launch from Steam | Game starts, menu shows v5.0.2-blitz |
| 2 | Play > Host Online Game (**the crash test**) | Lobby screen appears and stays up for at least 30 seconds |
| 3 | In the lobby, invite a friend / have them join via Steam friends or the lobby browser | They appear in the lobby |
| 4 | Joiner has vanilla Barony (not installed) | Should be refused (version mismatch), no crash on either side |
| 5 | Start the game with 2 players, play floor 1-3 | No crash, both see the same monsters/items |
| 6 | Optional: type `/enablecheats` then `/gotolevel 5` in the console (key `/`) | Jumps to floor 5 for both players |
| 7 | Quit to menu, then Host again | Works a second time |
| 8 | Run menu option 2 (Restore vanilla), start Barony | Vanilla Barony, your normal saves |

If you only have one PC: tests 1, 2, 7, 8 still tell me whether hosting works.

## What to send me
Run the Collect logs option after a failure (or after a clean session, if I ask), and send `blitz-logs.zip` together with a short note:

```
Windows version:
Test number that failed (from the table):
What I did right before:
What I saw (error window? game closed? froze?):
Host or joiner:
Did it happen every time?:
```

`blitz-logs.zip` contains `log.txt` (the game log), the `crashlogs` folder if the game crashed (a `.dmp` and a copy of the log), and `info.txt` (Windows version, hash of `barony.exe`, which mod files are installed). It does not contain saves, your Steam account details, or anything outside the Barony folder. Open `info.txt` first if you want to check.

If the game just closes with no message, look in `Barony\crashlogs\` anyway.

## Known harmless messages
- `failed hash check` lines in `log.txt` for lock-room submaps appear in the vanilla-based maps too.
