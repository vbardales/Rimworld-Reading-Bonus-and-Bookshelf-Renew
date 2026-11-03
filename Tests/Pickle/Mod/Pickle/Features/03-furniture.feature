# The two optional furniture mods (F5, F7). Each feature plays only in the pass that stages its mod
# (`@requires:` skips otherwise, and a skipped scenario is not a pass).
#
# Gloomy Furniture's bookshelf is `GL_Bookshelf` and Daily Furniture's are `ADH_book_A_A_FURNITURE` and
# `ADH_book_A_B_FURNITURE` (the defNames the patches in Mod/Patches target). Once patched they are bookcases
# of this mod's class: they store books, count for the reading bonus, and take the "max books per cell" setting.
@requires:Solaris.FurnitureBase @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.deffields
Feature: Reading Bonus and Bookshelf: Gloomy Furniture bookshelves are supported

  Background:
    Given the save "test-colony" is loaded
    And Nelim's Pickle Tools: a closed roofed room is built at (30, 30) of 5 by 5

  @timeout:300
  Scenario: a Gloomy bookshelf stores books and counts for the bonus
    Given Nelim's Pickle Tools: I place the decor "GL_Bookshelf" at (32, 33)
    And Nelim's Pickle Tools: I fill the storage building "GL_Bookshelf" at (32, 33) with 4 things "Novel" of quality Normal
    Then Nelim's Pickle Tools: the storage building "GL_Bookshelf" at (32, 33) holds 4 things
    And Nelim's Pickle Tools: the room at (31, 31) has the stat "ReadingBonus" at 1.01

  @timeout:300
  Scenario: the max books per cell setting reaches the Gloomy bookshelf and the reset restores it
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And Nelim's Pickle Tools: I set the option "maxBookInCell" of the mod "nelim.readingbonusandbookshelf" to "10"
    And Nelim's Pickle Tools: I close the mod options window
    Then Nelim's Pickle Tools: def "GL_Bookshelf" of type "ThingDef" field "building.maxItemsInCell" is "10"
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And I click button keyed "KTK_BookMod_ResetToDefault"
    And Nelim's Pickle Tools: I close the mod options window
    Then Nelim's Pickle Tools: def "GL_Bookshelf" of type "ThingDef" field "building.maxItemsInCell" is "30"
