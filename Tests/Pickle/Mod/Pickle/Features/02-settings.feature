# The settings window and what it drives (F2, F4, F9). Each scenario restores the defaults before it ends,
# because the settings file belongs to the machine, not to the saved game.
@requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.deffields
Feature: Reading Bonus and Bookshelf: the settings change the bonus and reset cleanly

  Background:
    Given the save "test-colony" is loaded
    And Nelim's Pickle Tools: a closed roofed room is built at (30, 30) of 5 by 5
    And Nelim's Pickle Tools: I place the decor "Bookcase" at (32, 33)
    And Nelim's Pickle Tools: I fill the storage building "Bookcase" at (32, 33) with 4 things "Novel" of quality Normal

  @timeout:300
  Scenario: a heavier normal weight raises the bonus, and reset brings it back
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And Nelim's Pickle Tools: I set the option "bounsNormal" of the mod "nelim.readingbonusandbookshelf" to "0.02"
    And Nelim's Pickle Tools: I close the mod options window
    Then Nelim's Pickle Tools: the settings file of the mod "nelim.readingbonusandbookshelf" holds "bounsNormal" as "0.02"
    And Nelim's Pickle Tools: the room at (31, 31) has the stat "ReadingBonus" at 1.02
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And I click button keyed "KTK_BookMod_ResetToDefault"
    And Nelim's Pickle Tools: I close the mod options window
    Then Nelim's Pickle Tools: the option "bounsNormal" of the mod "nelim.readingbonusandbookshelf" is "0.01"
    And Nelim's Pickle Tools: the room at (31, 31) has the stat "ReadingBonus" at 1.01

  @timeout:300
  Scenario: reset restores every setting, not only the one that was changed
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And Nelim's Pickle Tools: I set the option "bounsAwful" of the mod "nelim.readingbonusandbookshelf" to "0.1"
    And Nelim's Pickle Tools: I set the option "bounsLegendary" of the mod "nelim.readingbonusandbookshelf" to "0"
    And Nelim's Pickle Tools: I set the option "maxBookInCell" of the mod "nelim.readingbonusandbookshelf" to "5"
    And Nelim's Pickle Tools: I set the option "changeReadingBonus" of the mod "nelim.readingbonusandbookshelf" to "False"
    And I click button keyed "KTK_BookMod_ResetToDefault"
    And Nelim's Pickle Tools: I close the mod options window
    Then Nelim's Pickle Tools: the option "bounsAwful" of the mod "nelim.readingbonusandbookshelf" is "0.001"
    And Nelim's Pickle Tools: the option "bounsLegendary" of the mod "nelim.readingbonusandbookshelf" is "0.04"
    And Nelim's Pickle Tools: the option "maxBookInCell" of the mod "nelim.readingbonusandbookshelf" is "30"
    And Nelim's Pickle Tools: the option "changeReadingBonus" of the mod "nelim.readingbonusandbookshelf" is "True"

  @review @timeout:300
  Scenario: the settings window shows the toggle, the sliders and the reset button
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And I take a screenshot "settings-window"
    And Nelim's Pickle Tools: I close the mod options window
    Then no errors were logged

  # F3. The vanilla value is derived, not yet measured on this shelf: NPT's run of 2026-11-03 read 1.016 for
  # 2 Good novels in a vanilla Bookcase (0.4 of a cell at 0.04 a full cell, so 5 books a cell), hence
  # 4 novels = 0.8 of a cell = 1.032. Correct the number from the first run if it differs.
  @timeout:300
  Scenario: with the rework off the vanilla calculation applies, and reset brings the rework back
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And Nelim's Pickle Tools: I set the option "changeReadingBonus" of the mod "nelim.readingbonusandbookshelf" to "False"
    And Nelim's Pickle Tools: I close the mod options window
    Then Nelim's Pickle Tools: the room at (31, 31) has the stat "ReadingBonus" at 1.032
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And I click button keyed "KTK_BookMod_ResetToDefault"
    And Nelim's Pickle Tools: I close the mod options window
    Then Nelim's Pickle Tools: the room at (31, 31) has the stat "ReadingBonus" at 1.01
