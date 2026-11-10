# Daily Furniture's bookshelves (F5, F7); see 03-furniture.feature for the rules of the optional passes.
@requires:ZeroWhite.Dailyfurniture @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.deffields
Feature: Reading Bonus and Bookshelf: Daily Furniture bookshelves are supported

  Background:
    Given the save "test-colony" is loaded
    And Nelim's Pickle Tools: a closed roofed room is built at (70, 85) of 5 by 5

  @timeout:300
  Scenario Outline: a Daily Furniture bookshelf stores books and counts for the bonus
    Given Nelim's Pickle Tools: I place the decor "<shelf>" at (72, 88)
    And Nelim's Pickle Tools: I fill the storage building "<shelf>" at (72, 88) with 4 things "Novel" of quality Normal
    Then Nelim's Pickle Tools: the storage building "<shelf>" at (72, 88) holds 4 things
    And Nelim's Pickle Tools: the room at (71, 86) has the stat "ReadingBonus" at 1.01

    Examples:
      | shelf                  |
      | ADH_book_A_A_FURNITURE |
      | ADH_book_A_B_FURNITURE |

  @timeout:300
  Scenario Outline: the max books per cell setting reaches the Daily Furniture bookshelves
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And Nelim's Pickle Tools: I set the option "maxBookInCell" of the mod "nelim.readingbonusandbookshelf" to "10"
    And Nelim's Pickle Tools: I close the mod options window
    Then Nelim's Pickle Tools: def "<shelf>" of type "ThingDef" field "building.maxItemsInCell" is "10"
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And I click button keyed "KTK_BookMod_ResetToDefault"
    And Nelim's Pickle Tools: I close the mod options window
    Then Nelim's Pickle Tools: def "<shelf>" of type "ThingDef" field "building.maxItemsInCell" is "30"

    Examples:
      | shelf                  |
      | ADH_book_A_A_FURNITURE |
      | ADH_book_A_B_FURNITURE |
