using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Verse;

namespace KTK_BookMod;

public class KTK_BookMod : Mod
{
    public KTK_BookModSettings settings;

    public KTK_BookMod(ModContentPack content)
        : base(content)
    {
        settings = GetSettings<KTK_BookModSettings>();
    }

	// Every bookcase this mod supports.
	//
	// FIX: the original filtered on d.HasComp(typeof(Building_KTK_BookCase)), but
	// HasComp searches the COMPONENTS of a def while Building_KTK_BookCase is a
	// thingClass. The predicate was always false, this list stayed empty and
	// ChangeMaxBookInCell() did nothing. That is why the value used to be written
	// into the def at every spawn, a workaround for the bug rather than a fix.
    public static IEnumerable<ThingDef> LoadedAllBookCase =>
        DefDatabase<ThingDef>.AllDefsListForReading
            .Where(d => d.thingClass != null
                        && typeof(Building_KTK_BookCase).IsAssignableFrom(d.thingClass));

    public override void DoSettingsWindowContents(Rect inRect)
    {
        KTK_BookModSettings.DoSettingsWindowContents(inRect);
        base.DoSettingsWindowContents(inRect);
    }

    public override string SettingsCategory()
    {
        return "KTK_BookMod_ReadingBounsChange".Translate();
    }

    private static bool IsVanillaBookcase(ThingDef def)
    {
        return def.defName == "BookcaseSmall" || def.defName == "Bookcase";
    }

	// Refreshes the rooms that hold shelves so the reading bonus is recomputed at once.
    public static void ChangeReadingBonus()
    {
        if (Current.ProgramState != ProgramState.Playing) return;

        foreach (Map map in Find.Maps)
        {
            var seenRooms = new HashSet<int>();
            foreach (Building_KTK_BookCase shelf in
                     map.listerBuildings.AllBuildingsColonistOfClass<Building_KTK_BookCase>())
            {
                Room room = shelf.GetRoom();
                if (room != null && seenRooms.Add(room.ID)) room.Notify_TerrainChanged();
            }
        }
    }

	// Applies the per-cell capacity to non-vanilla shelves.
	//
	// maxItemsInCell is a DEF value, shared by every shelf of the same type, so it is
	// written once at startup and on every settings change, never when a building
	// spawns (the setting would then only apply to the next shelf placed).
    public static void ChangeMaxBookInCell()
    {
        foreach (ThingDef def in LoadedAllBookCase)
        {
            if (IsVanillaBookcase(def)) continue;
            if (def.building == null) continue;
            def.building.maxItemsInCell = (int)KTK_BookModSettings.maxBookInCell;
        }
    }

    public override void WriteSettings()
    {
        base.WriteSettings();
        ChangeMaxBookInCell();
        ChangeReadingBonus();
    }
}

// The setting must hold from load time, not only after a visit to the options window.
[StaticConstructorOnStartup]
public static class KTK_BookModStartup
{
    static KTK_BookModStartup()
    {
        KTK_BookMod.ChangeMaxBookInCell();
    }
}
