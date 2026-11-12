# In-game scenarios, run by Pickle

Written 2026-11-02, **never run**: no scenario here is a pass. The steps they use were added to PickleTools by NPT the same day (test ticket 4665, not played when this was written); do not rely on a result before a ticket has run on the revision to test.

`Mod/` is the test companion (`nelim.readingbonusandbookshelf.pickletests`, development only, never published). Offline checks live in `Tests/ReadingBonusAndBookshelf.Tests`; this suite keeps only what a running game shows.

## Features

| File | Scenarios | Covers (see `TESTING.md`) |
| --- | --- | --- |
| `01-reading-bonus.feature` | 6 blocks (the outline plays 7 qualities) | F1 every book counts, F6 vanilla bookcase still drawn (`@review`) |
| `02-settings.feature` | 4 | F2 weights, F3 toggle off (vanilla value derived from NPT's 1.016 for 2 books), F4 reset, F9 settings window (`@review`) |
| `03-furniture.feature` | 2 | F5, F7 with Gloomy Furniture (`@requires:Solaris.FurnitureBase`) |
| `05-gloomy-continued.feature` | 2 | F5, F7 with Gloomy Furniture (Continued) (`@requires:Gloomy.Furniture.Continued`) |
| `04-daily-furniture.feature` | 2 outlines (2 shelves each) | F5, F7 with Daily Furniture (`@requires:ZeroWhite.Dailyfurniture`) |

Each scenario loads `test-colony`, builds a closed roofed 5 by 5 room at (70, 85), places a bookcase at (72, 88) and checks the `ReadingBonus` room stat at (71, 86).

## Passes

| Pass | Map | Plays | Languages |
| --- | --- | --- | --- |
| Minimal | `wsl-deps.sans-facultatifs.map` | 01, 02 | English, then French |
| Gloomy Furniture | `wsl-deps.avec-gloomy.map` | 03 | English |
| Daily Furniture | `wsl-deps.avec-dailyfurniture.map` | 04 | English |
| Gloomy Furniture (Continued) | `wsl-deps.avec-gloomy-continued.map` | 05 | English |

```
Run-PickleWsl.ps1 -Mod ReadingBonusAndBookshelfRenew -DepMap wsl-deps.sans-facultatifs.map -Language English
```

Through the Ticket Manager only (`PICKLE.md`). The `Solaris.FurnitureBase` id (1558635181, the original GloomyFurniture) is borrowed from other suites; the dependency set of Daily Furniture is **not known**: read the staged and loaded mod lists at its first run.

## Not covered here, and why

- **F3 number:** the vanilla value in `02-settings.feature` is derived (1.016 measured by NPT for 2 Good novels, so 1.032 for 4), to confirm on the first run.
- **F8 (add or remove the mod in a save), F10 (hidden shortcut revealed by RIMMSQOL), F11 (French and Chinese layout), F12 (the original Kutake mod loaded):** need a removal request (`-ThenWithout`), RIMMSQOL staged, a human reading the captures, or the original mod staged. Planned for `playTests`.
- **Slider tooltips:** HoverSteps is available; the scenario is not written yet.
