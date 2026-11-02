using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using KTK_BookMod;
using RimWorld;
using Verse;

// Console tests, no game started: the mod's own code runs in this process against
// the game's assemblies. Covers the reading-bonus formula, the settings defaults and
// reset, and the XML the game loads (patches, shortcut def, translation keys).
// Anything that needs a running game belongs to the Pickle suite.
internal static class Program
{
	private static int passed;
	private static int failed;
	private static string root = "";

	private static void Check(string name, bool ok, string detail = "")
	{
		if (ok) { passed++; Console.WriteLine("PASS  " + name); }
		else { failed++; Console.WriteLine("FAIL  " + name + (detail.Length > 0 ? ": " + detail : "")); }
	}

	private static bool Near(float a, float b) => Math.Abs(a - b) < 1e-5f;

	private static string FindRoot()
	{
		string? dir = AppContext.BaseDirectory;
		while (dir != null && !File.Exists(Path.Combine(dir, "STATUS.md")))
		{
			dir = Path.GetDirectoryName(dir);
		}
		return dir ?? throw new InvalidOperationException("STATUS.md not found above " + AppContext.BaseDirectory);
	}

	private static void Defaults()
	{
		Check("default: reading bonus rework on", KTK_BookModSettings.changeReadingBonus);
		Check("default: awful 0.001", Near(KTK_BookModSettings.bounsAwful, 0.001f));
		Check("default: poor 0.005", Near(KTK_BookModSettings.bounsPoor, 0.005f));
		Check("default: normal 0.01", Near(KTK_BookModSettings.bounsNormal, 0.01f));
		Check("default: good 0.015", Near(KTK_BookModSettings.bounsGood, 0.015f));
		Check("default: excellent 0.02", Near(KTK_BookModSettings.bounsExcellent, 0.02f));
		Check("default: masterwork 0.03", Near(KTK_BookModSettings.bounsMasterwork, 0.03f));
		Check("default: legendary 0.04", Near(KTK_BookModSettings.bounsLegendary, 0.04f));
		Check("default: max books per cell 30", Near(KTK_BookModSettings.maxBookInCell, 30f));
	}

	private static float S(params QualityCategory?[] q) => KTK_RoomStatWorker_ReadingBonus.ScoreFromQualities(q);

	private static void Score()
	{
		Check("score: no book is 1.0", Near(S(), 1f));
		Check("score: one normal book is 1.0025", Near(S(QualityCategory.Normal), 1f + 0.01f / 4f));
		Check("score: four normal books is 1.01", Near(S(Enumerable.Repeat<QualityCategory?>(QualityCategory.Normal, 4).ToArray()), 1.01f));
		Check("score: forty normal books is 1.10", Near(S(Enumerable.Repeat<QualityCategory?>(QualityCategory.Normal, 40).ToArray()), 1.10f));
		Check("score: a book with no quality adds nothing", Near(S((QualityCategory?)null), 1f));
		var weights = new (QualityCategory q, float w)[]
		{
			(QualityCategory.Awful, KTK_BookModSettings.bounsAwful),
			(QualityCategory.Poor, KTK_BookModSettings.bounsPoor),
			(QualityCategory.Normal, KTK_BookModSettings.bounsNormal),
			(QualityCategory.Good, KTK_BookModSettings.bounsGood),
			(QualityCategory.Excellent, KTK_BookModSettings.bounsExcellent),
			(QualityCategory.Masterwork, KTK_BookModSettings.bounsMasterwork),
			(QualityCategory.Legendary, KTK_BookModSettings.bounsLegendary),
		};
		foreach (var (q, w) in weights)
		{
			Check("score: one " + q + " book uses its own weight", Near(S(q), 1f + w / 4f));
		}
		Check("score: mixed shelf is the sum of its weights",
			Near(S(QualityCategory.Awful, QualityCategory.Legendary, QualityCategory.Good), 1f + (0.001f + 0.04f + 0.015f) / 4f));
		float before = KTK_BookModSettings.bounsNormal;
		KTK_BookModSettings.bounsNormal = 0.02f;
		Check("score: a changed weight changes the score", Near(S(QualityCategory.Normal), 1f + 0.02f / 4f));
		KTK_BookModSettings.bounsNormal = before;
	}

	private static void Reset()
	{
		KTK_BookModSettings.changeReadingBonus = false;
		KTK_BookModSettings.bounsAwful = 0.1f;
		KTK_BookModSettings.bounsLegendary = 0f;
		KTK_BookModSettings.maxBookInCell = 5f;
		typeof(KTK_BookModSettings).GetMethod("ResetToDefault", BindingFlags.NonPublic | BindingFlags.Static)!.Invoke(null, null);
		Check("reset: toggle back on", KTK_BookModSettings.changeReadingBonus);
		Check("reset: awful back to default", Near(KTK_BookModSettings.bounsAwful, 0.001f));
		Check("reset: legendary back to default", Near(KTK_BookModSettings.bounsLegendary, 0.04f));
		Check("reset: max books back to default", Near(KTK_BookModSettings.maxBookInCell, 30f));
	}

	private static XDocument Load(string rel) => XDocument.Load(Path.Combine(root, rel));

	private static void Xml()
	{
		Assembly asm = typeof(KTK_BookModSettings).Assembly;

		XElement roomOp = Load("Mod/Patches/RoomReadingBonusPatch.xml").Descendants("Operation").Single();
		Check("xml: room patch replaces the ReadingBonus workerClass", (string)roomOp.Element("xpath")! == "/Defs/RoomStatDef[defName=\"ReadingBonus\"]/workerClass");
		string worker = (string)roomOp.Descendants("workerClass").Last();
		Type? workerType = asm.GetType(worker);
		Check("xml: room patch worker exists and is a RoomStatWorker", workerType != null && typeof(RoomStatWorker).IsAssignableFrom(workerType), worker);

		XElement bookOp = Load("Mod/Patches/VanillaBookCasePatch.xml").Descendants("Operation").Single();
		Check("xml: vanilla patch targets the abstract bookcase thingClass", ((string)bookOp.Element("xpath")!).Contains("thingClass=\"Building_Bookcase\""));
		string shelf = (string)bookOp.Descendants("thingClass").Last();
		Type? shelfType = asm.GetType(shelf);
		Check("xml: vanilla patch shelf class exists and is a Building_Bookcase", shelfType != null && typeof(Building_Bookcase).IsAssignableFrom(shelfType), shelf);

		foreach (string file in new[] { "DailyFurnitureBookshelfPatch.xml", "GloomyFurnitureBookShelfPatch.xml" })
		{
			XDocument doc = Load("Mod/Patches/" + file);
			XElement first = doc.Root!.Elements("Operation").First();
			Check("xml: " + file + " is guarded by PatchOperationFindMod", (string?)first.Attribute("Class") == "PatchOperationFindMod");
		}

		XElement button = Load("Mod/Defs/MainButtonDefs/KTK_BookMod_Settings.xml").Descendants("MainButtonDef").Single();
		Check("xml: shortcut is hidden by default", (string)button.Element("buttonVisible")! == "false");
		Check("xml: shortcut works without a map", (string)button.Element("validWithoutMap")! == "true");
		Type? buttonWorker = asm.GetType((string)button.Element("workerClass")!);
		Check("xml: shortcut worker exists and is a MainButtonWorker", buttonWorker != null && typeof(MainButtonWorker).IsAssignableFrom(buttonWorker));

		string about = File.ReadAllText(Path.Combine(root, "Mod/About/About.xml"));
		Check("xml: About names the packageId without patched or renew", about.Contains("<packageId>nelim.readingbonusandbookshelf</packageId>"));
		Check("xml: About carries the unofficial mark", about.Contains("(unofficial)</name>") && about.Contains("UNOFFICIAL."));
		string description = Regex.Match(about, "<description>.*?</description>", RegexOptions.Singleline).Value;
		Check("xml: About description names no RimWorld version", !Regex.IsMatch(description, "\\b1\\.[5-9]\\b"));
	}

	private static void Keys()
	{
		var used = new HashSet<string>();
		string source = Path.Combine(root, "Source");
		foreach (string cs in Directory.GetFiles(source, "*.cs", SearchOption.AllDirectories).Where(p => !p.Contains("obj")))
		{
			foreach (Match m in Regex.Matches(File.ReadAllText(cs), "\"(KTK_BookMod_\\w+)\"\\.Translate"))
			{
				used.Add(m.Groups[1].Value);
			}
		}
		Check("keys: the code calls 14 translation keys", used.Count == 14, used.Count.ToString());
		foreach (string lang in new[] { "English", "French", "ChineseSimplified (简体中文)" })
		{
			var keyed = Load("Mod/Languages/" + lang + "/Keyed/KTK_BookMod.Keys.xml").Root!.Elements().ToDictionary(e => e.Name.LocalName, e => e.Value);
			Check("keys: " + lang + " defines exactly the keys the code calls", keyed.Keys.ToHashSet().SetEquals(used));
			Check("keys: " + lang + " has no empty text", keyed.Values.All(v => v.Trim().Length > 0));
		}
		foreach (string lang in new[] { "French", "ChineseSimplified (简体中文)" })
		{
			var keys = Load("Mod/Languages/" + lang + "/DefInjected/MainButtonDef/MainButtons.xml").Root!.Elements().Select(e => e.Name.LocalName).ToHashSet();
			Check("keys: " + lang + " translates the shortcut label and description", keys.SetEquals(new[] { "KTK_BookMod_Settings.label", "KTK_BookMod_Settings.description" }));
		}
	}

	private static int Main()
	{
		root = FindRoot();
		Defaults();
		Score();
		Reset();
		Xml();
		Keys();
		Console.WriteLine();
		Console.WriteLine((passed + failed) + " checks, " + passed + " passed, " + failed + " failed");
		return failed == 0 ? 0 : 1;
	}
}
