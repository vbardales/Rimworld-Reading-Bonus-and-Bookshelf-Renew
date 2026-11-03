# The reading bonus of a room, from the books on its shelves (F1, F6).
#
# The bonus is 1 + (the sum of one weight per book) / 4, one weight per quality (defaults per mille:
# awful 1, poor 5, normal 10, good 15, excellent 20, masterwork 30, legendary 40). The arithmetic itself is
# checked offline (Tests/ReadingBonusAndBookshelf.Tests); what only the game shows is that the replaced
# room stat worker is the one the game calls, on real Book things in a real bookcase of a real room.
#
# Every scenario builds its own 5 by 5 room at (30, 30) on a freshly loaded test-colony and starts from the
# default settings; a scenario that changes a setting restores it (see 02-settings.feature).
@requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.deffields
Feature: Reading Bonus and Bookshelf: the reading bonus counts every book

  Background:
    Given the save "test-colony" is loaded
    And Nelim's Pickle Tools: a closed roofed room is built at (30, 30) of 5 by 5

  @timeout:300
  Scenario: the settings start at their documented defaults
    Then Nelim's Pickle Tools: the option "changeReadingBonus" of the mod "nelim.readingbonusandbookshelf" is "True"
    And Nelim's Pickle Tools: the option "bounsNormal" of the mod "nelim.readingbonusandbookshelf" is "0.01"
    And Nelim's Pickle Tools: the option "bounsLegendary" of the mod "nelim.readingbonusandbookshelf" is "0.04"
    And Nelim's Pickle Tools: the option "maxBookInCell" of the mod "nelim.readingbonusandbookshelf" is "30"

  @timeout:300
  Scenario: a bookcase with no book adds nothing
    Given Nelim's Pickle Tools: I place the decor "Bookcase" at (32, 33)
    Then Nelim's Pickle Tools: the room at (31, 31) has the stat "ReadingBonus" at 1

  @timeout:300
  Scenario: four normal books in one bookcase raise the bonus by a quarter of their weights
    Given Nelim's Pickle Tools: I place the decor "Bookcase" at (32, 33)
    And Nelim's Pickle Tools: I fill the storage building "Bookcase" at (32, 33) with 4 things "Novel" of quality Normal
    Then Nelim's Pickle Tools: the storage building "Bookcase" at (32, 33) holds 4 things
    And Nelim's Pickle Tools: the room at (31, 31) has the stat "ReadingBonus" at 1.01

  @timeout:300
  Scenario: every book counts, not one per cell: a second bookcase of four doubles the gain
    Given Nelim's Pickle Tools: I place the decor "Bookcase" at (32, 33)
    And Nelim's Pickle Tools: I place the decor "Bookcase" at (30, 33)
    And Nelim's Pickle Tools: I fill the storage building "Bookcase" at (32, 33) with 4 things "Novel" of quality Normal
    And Nelim's Pickle Tools: I fill the storage building "Bookcase" at (30, 33) with 4 things "Novel" of quality Normal
    Then Nelim's Pickle Tools: the room at (31, 31) has the stat "ReadingBonus" at 1.02

  @timeout:300
  Scenario Outline: each quality uses its own weight
    Given Nelim's Pickle Tools: I place the decor "Bookcase" at (32, 33)
    And Nelim's Pickle Tools: I fill the storage building "Bookcase" at (32, 33) with 4 things "Novel" of quality <quality>
    Then Nelim's Pickle Tools: the room at (31, 31) has the stat "ReadingBonus" at <bonus>

    Examples:
      | quality    | bonus |
      | Awful      | 1.001 |
      | Poor       | 1.005 |
      | Normal     | 1.01  |
      | Good       | 1.015 |
      | Excellent  | 1.02  |
      | Masterwork | 1.03  |
      | Legendary  | 1.04  |

  @review @timeout:300
  Scenario: a filled vanilla bookcase still draws its books
    Given Nelim's Pickle Tools: I place the decor "Bookcase" at (32, 33)
    And Nelim's Pickle Tools: I fill the storage building "Bookcase" at (32, 33) with 4 things "Novel" of quality Good
    When I take a screenshot "bookcase-vanilla-filled"
    Then no errors were logged
