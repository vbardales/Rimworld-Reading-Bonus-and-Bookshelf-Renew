# What only this mod asserts: identity (packageId, unofficial mark, Workshop id), the two core patches and their targets,
# the guard of each optional-furniture patch, and the hidden settings shortcut.
# The formula, the settings defaults and the translation key coverage stay in the compiled suite (Tests/Program.cs, Run-UnitTests.ps1).
# The generic checks (XML, defNames, textures, patch targets, translation coverage) are the shared scripts', run by Test-Mod.ps1.
# Takes -ModRoot (repository root) and -SharedDir (unused, kept for the Test-Mod.ps1 contract); prints findings, exits 1 on any.
param([string]$ModRoot = (Join-Path $PSScriptRoot '..'), [string]$SharedDir)
$ErrorActionPreference = 'Stop'
$ModRoot = (Resolve-Path -LiteralPath $ModRoot).Path
$mod = Join-Path $ModRoot 'Mod'
$script:findings = New-Object System.Collections.Generic.List[string]
function Assert-True($Condition, [string]$Message) { if (-not $Condition) { $script:findings.Add("FAIL: $Message") } }
function Read-Xml([string]$Path) { $x = New-Object System.Xml.XmlDocument; $x.Load((Join-Path $mod $Path)); $x }

$about = Read-Xml 'About/About.xml'
$meta = $about.ModMetaData
Assert-True ($meta.packageId -ceq 'nelim.readingbonusandbookshelf') 'packageId is nelim.readingbonusandbookshelf'
Assert-True ($meta.name -clike '*(unofficial)') 'name carries the (unofficial) mark'
Assert-True ($meta.description -cmatch '^UNOFFICIAL\.') 'description opens with UNOFFICIAL.'
Assert-True (@($meta.supportedVersions.li) -contains '1.6') 'RimWorld 1.6 declared'
Assert-True ((Get-Content (Join-Path $mod 'About/PublishedFileId.txt') -Raw).Trim() -ceq '3811391948') 'Workshop PublishedFileId is 3811391948'

$room = Read-Xml 'Patches/RoomReadingBonusPatch.xml'
$op = $room.SelectSingleNode('/Patch/Operation')
Assert-True ($op.xpath -ceq '/Defs/RoomStatDef[defName="ReadingBonus"]/workerClass') 'room patch targets the ReadingBonus workerClass'
Assert-True ($op.value.workerClass -ceq 'KTK_BookMod.KTK_RoomStatWorker_ReadingBonus') 'room patch installs KTK_RoomStatWorker_ReadingBonus'

$vanilla = Read-Xml 'Patches/VanillaBookCasePatch.xml'
$op = $vanilla.SelectSingleNode('/Patch/Operation')
Assert-True ($op.xpath -ceq '/Defs/ThingDef[thingClass="Building_Bookcase"]/thingClass') 'vanilla patch targets the Building_Bookcase thingClass'
Assert-True ($op.value.thingClass -ceq 'KTK_BookMod.Building_KTK_BookCase') 'vanilla patch installs Building_KTK_BookCase'

foreach ($file in 'DailyFurnitureBookshelfPatch.xml', 'GloomyFurnitureBookShelfPatch.xml') {
    $xml = Read-Xml "Patches/$file"
    $first = @($xml.SelectNodes('/Patch/Operation'))[0]
    Assert-True ($first.Class -ceq 'PatchOperationFindMod') "$file is guarded by PatchOperationFindMod"
}
$gloomy = Read-Xml 'Patches/GloomyFurnitureBookShelfPatch.xml'
Assert-True (@($gloomy.SelectNodes('/Patch/Operation/mods/li') | ForEach-Object { $_.InnerText }) -contains 'GloomyFurniture (Continued)') 'Gloomy patch names GloomyFurniture (Continued)'

$button = (Read-Xml 'Defs/MainButtonDefs/KTK_BookMod_Settings.xml').SelectSingleNode('/Defs/MainButtonDef')
Assert-True ($button.defName -ceq 'KTK_BookMod_Settings') 'settings shortcut def exists'
Assert-True ($button.buttonVisible -ceq 'false') 'settings shortcut is hidden by default'
Assert-True ($button.validWithoutMap -ceq 'true') 'settings shortcut works without a map'

if ($script:findings.Count -gt 0) { $script:findings | ForEach-Object { Write-Output $_ }; exit 1 }
Write-Output 'Rule-OwnValues: all own facts hold'
