---
mod: Reading Bonus and Bookshelf Renew (unofficial)
packageId: nelim.readingbonusandbookshelf
repo: Rimworld-Reading-Bonus-and-Bookshelf-Renew
remote: https://github.com/vbardales/Rimworld-Reading-Bonus-and-Bookshelf-Renew.git
visibility: public
detached: yes
workflow_stage: settings[1.0.0]
licence: silent
licence_at: "2026-11-02: source 3463926737 (Kutake) dead (last update 2025-04-14, 1.5 only), no licence, no reuse permission, no repository named; credit and removal on request, see ATTRIBUTION.md"
upstream_mod_remotes: N/A
settings_audit: unchecked
localization: unchecked
translation_en: unchecked
translation_fr: unchecked
dependencies: "2026-11-02: modDependencies Core only; optional integrations by PatchOperationFindMod on names: Daily furniture (3024562670), GloomyFurniture (1558635181) and Gloomy Furniture Fix; no DLC, no Harmony; loadAfter packageIds seen in other mods About.xml (Search-Workshop 2026-11-02, 9565 folders): ZeroWhite.Dailyfurniture, jxw.dailyfurniturefix, solaris.furniturebase, gloomy.furniture.fix"
workshop: 3811391948
published: no
tested_on: never
remaining:
  - "2026-11-02: 1.c done: Patch now means a link between two mods, this is a corrected copy so Renew (rule of Virginie via Audit); packageId changed to nelim.readingbonusandbookshelf, Workshop item 3811391948 kept, it was hidden at 0.1.0 when the id changed"
  - "2026-11-02: declareDependencies done (4.d ids confirmed by corpus search, Harmony loadAfter dropped). feature to decide: the installed GloomyFurniture fork is named GloomyFurniture (Continued) (Gloomy.Furniture.Continued, 3240958004) so the PatchOperationFindMod on name GloomyFurniture does not match it; not patched"
  - "2026-11-02: Preview.config.json still says Patched, fix at mountPreview"
  - "2026-11-02: unverified: never seen running"
protocols_read_sha: 72aa47f6a2d697aabdaf7c56276e3cc6f58291c2
updated: 2026-11-02
---

# Reading Bonus and Bookshelf Renew (unofficial): status

Current state only: the front matter above is the source of truth, run lines go to `docs/runs/`.
Check it with `scripts/Check-Status.ps1 -Mod ReadingBonusAndBookshelfRenew` (no ERROR) before the first commit.
