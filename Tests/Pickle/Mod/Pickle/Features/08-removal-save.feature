# F8, launch 1 of 2: a save made WITH the mod (a room, a bookcase holding four books). Launch 2 (09) loads it
# WITHOUT the mod: -Filter '08-removal-save' -Then '09-removal-load' -ThenWithout nelim.readingbonusandbookshelf.
@requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.deffields @requires:nelim.pickletools.savesteps
Feature: Reading Bonus and Bookshelf: a save made with the mod (1 of 2)

  @timeout:300
  Scenario: the save with a stocked bookcase is written
    Given the save "test-colony" is loaded
    And Nelim's Pickle Tools: a closed roofed room is built at (70, 85) of 5 by 5
    And Nelim's Pickle Tools: I place the decor "Bookcase" at (72, 88)
    And Nelim's Pickle Tools: I fill the storage building "Bookcase" at (72, 88) with 4 things "Novel" of quality Normal
    Then Nelim's Pickle Tools: the room at (71, 86) has the stat "ReadingBonus" at 1.01
    When Nelim's Pickle Tools: the game is saved as "rbab-removal"
