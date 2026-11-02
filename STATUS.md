---
mod: Reading Bonus and Bookshelf Renew (unofficial)
packageId: nelim.readingbonusandbookshelf
repo: Rimworld-Reading-Bonus-and-Bookshelf-Renew
remote: https://github.com/vbardales/Rimworld-Reading-Bonus-and-Bookshelf-Renew.git
visibility: public
detached: yes
workflow_stage: writeTests[1.0.0]
licence: silent
licence_at: "2026-11-02: source 3463926737 (Kutake) dead (last update 2025-04-14, 1.5 only), no licence, no reuse permission, no repository named; credit and removal on request, see ATTRIBUTION.md"
upstream_mod_remotes: N/A
settings_audit: partial
localization: partial
translation_en: complete
translation_fr: complete
dependencies: "2026-11-02: modDependencies Core only; optional integrations by PatchOperationFindMod on names: Daily furniture (3024562670), GloomyFurniture (1558635181) and Gloomy Furniture Fix; no DLC, no Harmony; loadAfter packageIds seen in other mods About.xml (Search-Workshop 2026-11-02, 9565 folders): ZeroWhite.Dailyfurniture, jxw.dailyfurniturefix, solaris.furniturebase, gloomy.furniture.fix"
workshop: 3811391948
published: no
tested_on: never
remaining:
  - "2026-11-02: 1.c done: Patch now means a link between two mods, this is a corrected copy so Renew (rule of Virginie via Audit); packageId changed to nelim.readingbonusandbookshelf, Workshop item 3811391948 kept, it was hidden at 0.1.0 when the id changed"
  - "2026-11-02: declareDependencies done (4.d ids confirmed by corpus search, Harmony loadAfter dropped). feature to decide: the installed GloomyFurniture fork is named GloomyFurniture (Continued) (Gloomy.Furniture.Continued, 3240958004) so the PatchOperationFindMod on name GloomyFurniture does not match it; not patched"
  - "2026-11-02: Preview.config.json still says Patched, fix at mountPreview"
  - "2026-11-02: unverified: settings in game (primary access, hidden MainButtons shortcut, RIMMSQOL reveal, effect, persistence, logs), never seen running"
  - "2026-11-02: unverified: raw keys, fallback text and clipping in game at playTests"
  - "2026-11-02: feature: 7.d Pickle suites not written yet (plan in TESTING.md: 4 passes). Blocked on NPT: three steps asked through the TM on 2026-11-02 (room with a filled bookcase and its ReadingBonus value; set a mod setting and press Reset; assert a ThingDef field), answer awaited"
  - "2026-11-02: unverified: 7.g needs localization complete (partial until playTests) and the French re-read"
protocols_read_sha: 3aab9cb0a46ad9091084fc47a249b97f4c8fd25e
updated: 2026-11-02
---

# Reading Bonus and Bookshelf Renew (unofficial): status

Current state only: the front matter above is the source of truth, run lines go to `docs/runs/`.
Check it with `scripts/Check-Status.ps1 -Mod ReadingBonusAndBookshelfRenew` (no ERROR) before the first commit.

## Settings audit

Date 2026-11-02, revision after commit 99cd066, files `Source/ReadingBonusAndBookshelfPatch/KTK_BookModSettings.cs`, `KTK_BookMod.cs`, `MainButtonWorker_KTK_BookModSettings.cs`, `Mod/Defs/MainButtonDefs/KTK_BookMod_Settings.xml`. Result: `partial` (code and definition analysis done, in-game checks `unverified`).

Inventory and rationale (all inherited from Kutake, all useful):

| Setting | Use | Applies |
| --- | --- | --- |
| Change reading bonus calculation (toggle) | one switch back to vanilla behaviour | value read each time the room stat is computed; rooms with shelves are refreshed when the settings window closes (`ChangeReadingBonus`) |
| 7 sliders, one per book quality (0 to 100 per mille) | how much each book adds to a room's reading bonus | when the settings window closes (rooms refreshed) |
| Max books per cell (5 to 100, default 30) | capacity of bookcases from Daily Furniture and Gloomy Furniture, vanilla shelves excluded | when the settings window closes (`WriteSettings`) and at startup |
| Reset to default | restores all of the above | same timing as each setting |

Scope: global (mod settings file), not per save. No setting is invented; none exposes an internal constant.

Access: primary route Options > Mod settings > the mod name (`SettingsCategory()` returns the key `KTK_BookMod_ReadingBounsChange`). The shortcut is new: `MainButtonDef KTK_BookMod_Settings` with `buttonVisible=false` and `validWithoutMap=true`, worker `MainButtonWorker_KTK_BookModSettings` opens `Dialog_ModSettings` on the same `KTK_BookMod` instance (same values, same persistence, no customization mod required). Pattern taken from JoyRescue.

Usage review fixes made today: tooltips on the 7 quality sliders and on max books (what it does, when it applies); the max-books slider, which was silently hidden without a supported furniture mod, now shows a greyed line saying which mods it needs.

Commands: `dotnet build` Release 0 errors; `Check-ModBasics` PASS (11 XML, 1 def); `Check-Translations` PASS (14 Keyed calls); `Check-DefInjected` 4 keys, 0 errors.

Not done (`unverified`, in `remaining`): everything that needs the game, at `playTests`: first use, primary access, actual effect of each option, persistence across restart and save, input bounds, reset, optional furniture present or absent, shortcut hidden on a clean configuration, RIMMSQOL reveal and hide, log robustness. No unit-test project exists for this mod. Known limit: the max-books slider is greyed out only by a note, not disabled, and the Chinese texts are machine-written.

## Translation audit

Date 2026-11-02, revision 01d4456 (+ this commit). Languages shipped: English (`Languages/English/Keyed`), French and Simplified Chinese (Keyed, plus `DefInjected/MainButtonDef` for the shortcut). English of the shortcut lives in the Def fields.

- **6.a Inventory:** 14 `Translate()` calls in `KTK_BookModSettings.cs` and `KTK_BookMod.cs`, 14 keys in each Keyed file (`Check-Translations` PASS: coverage, duplicates, stale entries, tokens). No other displayed text in code: `Building_KTK_BookCase.cs` and the room stat worker carry only a def name comparison. One `MainButtonDef` (label, description). `About.xml` is not localizable. The per-mille sign in the slider labels is a unit symbol, not a word.
- **6.b Localizable:** all texts are stable `KTK_BookMod_*` Keyed keys resolved by `.Translate()`; no number or plural built by hand; no hard-coded text.
- **6.c Coverage:** `Check-DefInjected` 4 keys, 0 errors; every key non-empty in English, French and Chinese.
- **6.d French agreement:** no text addresses a pawn, so no gender segment needed; no tu, vous, nous or imperative aimed at the player (infinitive and impersonal forms only); no "(e)" or slash.
- **6.e Gendered French choice:** n/a, no pawn-agreeing text.
- **6.f** `FRENCH_REVIEW.md` generated by `Make-FrenchReview.ps1` at revision 01d4456; no doubtful text flagged.
- **6.g Virginie's review:** done 2026-11-02 by Virginie, revision e30e408; KTK_BookMod_bounsTip (reworded to say the total is divided by 4) re-read and approved by Virginie the same day, with the following two ChatGPT style suggestions declined (`FRENCH_REVIEW.md` regenerated at 037556a), French texts approved; correction made: "demande" became "nécessite" in `KTK_BookMod_maxBookInCellUnavailable` (ChatGPT review, accepted). Three ChatGPT reviews run; « Réinitialiser les valeurs par défaut » and « merveille » kept because the game's French pack uses exactly them (`ResetBinding`, `QualityCategory_Masterwork`). The Chinese texts are machine-written and outside this review.

## Testing (writeTests)

2026-11-02: `Tests/ReadingBonusAndBookshelf.Tests.csproj` written, run with `Run-UnitTests.ps1 -PreBuild`: 48 checks, 48 passed, 0 failed; the tested DLL (`Tests/build/test-mod`) is byte-identical to `Mod/Assemblies/KTK_BookPatch.dll` (`cmp`). The XML checks (7.c) live in the same executable (patches, shortcut def, About, translation keys). To make the formula testable, `ScoreFromQualities` was extracted from the room stat worker with no change of behaviour; code comments and the csproj comment were translated to English. The tooltip of the quality sliders was corrected to say the total is divided by 4. Functional scenarios F1 to F12 are in `TESTING.md`; no local script was added (shared `Run-UnitTests.ps1` only).

Tested sha (7.f): offline suite run on the code of `39c8bc1`, 48/48; no `Source/` or `Mod/` change since (only `STATUS.md`, `FRENCH_REVIEW.md` regenerated). Any later code commit reopens 7.b and 7.c.
