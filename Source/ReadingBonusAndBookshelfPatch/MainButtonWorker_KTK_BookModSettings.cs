using RimWorld;
using Verse;

namespace KTK_BookMod;

// Optional shortcut to the mod settings, hidden by default (buttonVisible=false in
// the MainButtonDef). A customization mod such as RIMMSQOL can reveal it. It opens
// the same Mod instance as Options > Mod settings.
public class MainButtonWorker_KTK_BookModSettings : MainButtonWorker
{
	public override void Activate()
	{
		KTK_BookMod mod = LoadedModManager.GetMod<KTK_BookMod>();
		if (mod != null)
		{
			Find.WindowStack.Add(new Dialog_ModSettings(mod));
		}
	}
}
