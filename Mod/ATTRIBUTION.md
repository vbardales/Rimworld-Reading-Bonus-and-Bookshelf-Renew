# Reading Bonus and Bookshelf Renew (unofficial): attribution

1.6 update of **阅读加成与书架patch**
(https://steamcommunity.com/sharedfiles/filedetails/?id=3463926737), by
**Kutake**. The original stays on 1.5.

Original `packageId`: `Kutake.ReadingBoundsAndBookshelfPatch`.

**The design and the code are Kutake's.** This repository adds no feature: it
recompiles the assembly against 1.6, checks that the patch targets still hold,
and fixes one defect, which is why the mod is called "Renew" rather than a plain
"1.6".

## Licence

**No licence declared**: there is no `LICENSE` file in the mod, and the Steam
description is a single line with no word on reuse. The republication therefore
follows the established practice for taking over abandoned Workshop mods:
explicit credit to the original author, a link to the source mod, and immediate
removal on the author's simple request. This is stated plainly in the mod
description, not only here.

## What was taken over

| Element | Source |
| --- | --- |
| `KTK_RoomStatWorker_ReadingBonus`, `Building_KTK_BookCase`, `KTK_BookMod`, `KTK_BookModSettings` | `1.5/Assemblies/KTK_BookPatch.dll`, decompiled |
| The four XML patches | `1.5/Patches/` |
| English and Simplified Chinese keys | `Languages/` |

**The namespace `KTK_BookMod` and the assembly name `KTK_BookPatch` are kept.**
The XML patches target `KTK_BookMod.*`, and RimWorld stores settings under the
name of the `Mod` class: renaming either would break continuity with Kutake's
version and lose the settings of a game in progress. Only the display name and
the `packageId` change, as the convention for takeovers requires.

## What 1.6 required changing

**Nothing.** The assembly compiles as is against `Krafs.Rimworld.Ref` 1.6: none
of the APIs used has disappeared or changed signature: `Building_Bookcase`,
`CellsFilledPercentage`, `HeldBooks`, `MaximumBooks`, `RotOffsets`,
`VerticalGraphic`, `RoomStatWorker.GetScore`,
`SilhouetteUtility.DrawGraphicSilhouette`, `DrawAt(Vector3, bool)`.

The work was therefore verification, not rewriting:

- **`RoomStatDef ReadingBonus` still exists** and still carries a
  `<workerClass>`, so the `PatchOperationReplace` applies. This is the point that
  would have silently disabled everything had it moved.
- **The vanilla bookcase patch targets `BookcaseBase`**, the abstract def, and
  not `Bookcase` / `BookcaseSmall`. Patch operations run on the XML before
  inheritance is resolved, so one operation covers both vanilla bookcases.
  Checked: `BookcaseBase` is still the only def that declares
  `<thingClass>Building_Bookcase</thingClass>`.
- **The 1.6 `Building_Bookcase.DrawAt` was compared line by line** with Kutake's
  reimplementation: the book position calculation is identical (same 0.155 / 0.16
  step, same `RotOffsets`, same bookend handling), so drawing stays correct.
  `Thing.DrawAt`, which `DrawCase` replaces, still boils down to the same
  `Graphic.Draw` followed by the silhouette: nothing is lost by bypassing it.

## The defect fixed

**The "maximum books per cell" setting never applied by itself.** The cause is a
confusion between two game notions:

```csharp
d.HasComp(typeof(Building_KTK_BookCase))
```

`HasComp` searches a def's **components**, while `Building_KTK_BookCase` is a
**thingClass**. The predicate was therefore always false: `LoadedAllBookCase`
returned an empty list and `ChangeMaxBookInCell()` did nothing.

The author had worked around it by writing the value into the def every time a
shelf spawned, in `SpawnSetup`. Two consequences:

- lowering the setting mid-game changed nothing until a new shelf was placed;
- `maxItemsInCell` being a **def** value, hence shared, it stayed modified until
  the game restarted, even after the mod was disabled.

**Fix:** the lookup now matches on `thingClass`, and the setting is applied once
at startup and again on every change. The write at spawn time was removed.

## The labels

Two changes, both in `Languages/`, no code touched.

**The name shown in the settings.** `SettingsCategory()` returns the key
`KTK_BookMod_ReadingBounsChange`, which was "阅读加成逻辑改变" /
"Reading Bonus Logic Modified". In Kutake's version it was a section title, not a
mod name: the Options, Mod settings list therefore showed a phrase nobody could
find when looking for the mod by name. The key now carries the mod name, the same
in all three languages, like the `About.xml` name, which is not localizable and
so shows in English everywhere. Nothing is lost: the checkbox just below already
says what the mod changes.

**French added**, `Languages/French/Keyed/KTK_BookMod.Keys.xml`. The vocabulary
is taken from the game, not freely translated: `bonus de lecture`
(`RoomStatDef ReadingBonus`), `case` for a map cell, and the seven qualities in
the parenthesized form the game already uses for items: `Livres (merveille)` like
`bibliotheque (merveille)`, with the exact terms of `Keyed/Enums.xml`: horrible,
mediocre, normal, bon, excellent, merveille, legendaire.

The three files declare the same eleven keys, and those eleven keys are exactly
the ones the code calls.

## Source check (2026-11-02)

Steam API `GetPublishedFileDetails` on 3463926737: title "阅读加成与书架patch", created and last updated 2025-04-14 (same timestamp, never updated since), tagged 1.5 only, public, not banned, 379 lifetime subscriptions. The description states no licence and no reuse permission, and names no source repository. Source judged dead (no update in 19 months, no 1.6 support); licence stays `silent`. Comments not read (page fetch returned HTTP 429).
