# Testing: Reading Bonus and Bookshelf Renew (unofficial)

Revision under test: the commit that carries this file (see `STATUS.md`, `tested sha`). Nothing here has run in game yet.

## What is automated (no game started)

`Tests/ReadingBonusAndBookshelf.Tests.csproj` is a console project that loads the shipped `Mod/Assemblies/KTK_BookPatch.dll` next to the game's assemblies and runs the mod's own code.

```
powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Run-UnitTests.ps1 -ModRoot <mod folder> -PreBuild Source/ReadingBonusAndBookshelfPatch/KTK_BookPatch.csproj
```

`-PreBuild` builds the mod into `Tests/build/test-mod` and tests that DLL. Compare it with the shipped one (`cmp Tests/build/test-mod/KTK_BookPatch.dll Mod/Assemblies/KTK_BookPatch.dll`) before recording a result.

| Area | Checks | What it proves |
| --- | --- | --- |
| Defaults | 9 | the documented defaults of the toggle, the 7 quality weights and max books per cell |
| Score | 14 | `ScoreFromQualities`: empty room 1.0, one normal book 1.0025, four normal books 1.01, forty normal books 1.10, a book with no quality adds nothing, each tier uses its own weight, a mixed shelf sums its weights, a changed weight changes the score |
| Reset | 4 | the reset routine restores the toggle, awful, legendary and max books |
| XML | 12 | the room patch and the vanilla bookcase patch point at classes that exist with the right base type, the two furniture patches are guarded by `PatchOperationFindMod`, the shortcut def is hidden, needs no map and binds an existing worker, `About.xml` carries the packageId and the unofficial mark and names no RimWorld version |
| Keys | 9 | the code calls 14 translation keys; English, French and Chinese define exactly those keys with no empty text; the shortcut label and description are translated in French and Chinese |

Last run: 48 checks, 48 passed, 0 failed.

Out of scope, by design: how vanilla `Building_Bookcase`, the vanilla room stat or the furniture mods behave when this mod does not change them.

## Functional scenarios (need the game)

Figures are the code's: the bonus of a room is `1 + (sum of the weight of every book) / 4`, one weight per quality (defaults per mille: awful 1, poor 5, normal 10, good 15, excellent 20, masterwork 30, legendary 40). Test shelves are filled by the scenario, their capacity is never assumed.

| Id | Behaviour promised | Preconditions | Actions | Expected |
| --- | --- | --- | --- | --- |
| F1 | Every book counts, not one per cell | rework on (default), a closed room with one vanilla bookcase | fill it with 4 normal books, read the room's reading bonus; add 4 more | the bonus rises with each book: 1.01, then 1.02 |
| F2 | Quality weights are configurable | same room, 4 normal books | set the normal weight to 20 per mille, close the window | the bonus goes from 1.01 to 1.02 |
| F3 | Original behaviour is one toggle away | same room, 8 normal books | untick "Change reading bonus calculation", close the window | the bonus is the vanilla value for that shelf, not 1.02 |
| F4 | Reset button | any value changed | press "Reset to Default" and close | all values back to the defaults of the table above |
| F5 | Max books per cell for the supported furniture shelves | Daily Furniture or Gloomy Furniture loaded, one of its bookshelves | set max books per cell to 10, close the window; check the shelf | the shelf holds 10 books per cell; vanilla bookcases are unchanged |
| F6 | Vanilla bookcases are supported and still drawn | no optional mod | place a `Bookcase` and a `BookcaseSmall`, fill them | books are drawn on the shelves, the room bonus counts them |
| F7 | Daily Furniture and Gloomy Furniture shelves are supported | each mod loaded in turn | place one of its bookshelves, fill it | it stores books and counts for the bonus; without the mod nothing is patched and nothing is logged |
| F8 | Safe in an ongoing save | a save made without the mod | add the mod, load, then remove it | the save loads both times, the bonus is vanilla again after removal, bookcases remain |
| F9 | Settings access | clean configuration | open Options, Mod settings, then the mod name | the window shows the toggle, 7 sliders with tooltips, the reset button; max books slider or its greyed note |
| F10 | Hidden shortcut | clean configuration, then RIMMSQOL | check the main buttons bar; reveal the button in RIMMSQOL and click it | hidden by default (neither visible nor greyed); once revealed it opens the same window with the same values |
| F11 | French and Chinese | language set to French, then Simplified Chinese | open the settings window and hover each slider | no raw key, no clipped text, the tooltips read as in `FRENCH_REVIEW.md` |
| F12 | Incompatibility with the original | `Kutake.ReadingBoundsAndBookshelfPatch` also loaded | start the game | the game warns of the declared incompatibility |

## Pickle suites (written, not run)

`Tests/Pickle/` holds 14 scenario blocks in 4 features and 3 passes (minimal, Gloomy Furniture, Daily Furniture); `Tests/Pickle/README.md` gives the matrix, the commands and what is left out and why. `Check-Steps.ps1` resolves every step line to exactly one expression. Nothing has run: F1 to F7 and F9 are covered on paper only. F8, F10, F11 and F12 stay manual or wait for a first run (reasons in the README). Any step a scenario still needs goes to NPT, never a local step.
