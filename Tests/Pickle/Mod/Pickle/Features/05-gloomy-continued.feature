# Gloomy Furniture (Continued), 3240958004, the maintained fork of the original (F5, F7 again, same GL_Bookshelf). Each feature plays only in the pass that stages its mod
# (`@requires:` skips otherwise, and a skipped scenario is not a pass).
#
# Gloomy Furniture's bookshelf is `GL_Bookshelf` and Daily Furniture's are `ADH_book_A_A_FURNITURE` and
# `ADH_book_A_B_FURNITURE` (the defNames the patches in Mod/Patches target). Once patched they are bookcases
# of this mod's class: they store books, count for the reading bonus, and take the "max books per cell" setting.
@requires:Gloomy.Furniture.Continued @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.deffields
Feature: Reading Bonus and Bookshelf: Gloomy Furniture (Continued) bookshelves are supported

  Background:
    Given the save "test-colony" is loaded
    And Nelim's Pickle Tools: a closed roofed room is built at (70, 85) of 5 by 5

  @timeout:300
  Scenario: a Gloomy bookshelf stores books and counts for the bonus
    Given Nelim's Pickle Tools: I place the decor "GL_Bookshelf" at (72, 88)
    And Nelim's Pickle Tools: I fill the storage building "GL_Bookshelf" at (72, 88) with 4 things "Novel" of quality Normal
    Then Nelim's Pickle Tools: the storage building "GL_Bookshelf" at (72, 88) holds 4 things
    And Nelim's Pickle Tools: the room at (71, 86) has the stat "ReadingBonus" at 1.01

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
