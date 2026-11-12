# F10 and F12. F10: the settings shortcut is hidden by default and RIMMSQOL's own list can reveal it; the revealed
# button opens the same settings window. F12: this mod declares the original Kutake mod incompatible
# (the game's own warning in the mod list is the game's, so the declaration in About.xml is what is asserted).
# Played only by the pass "avec-rimmsqol" (RIMMSQOL staged). Every scenario ends with the choice forgotten.
@review @rimmsqol @requires:nelim.pickletools.rimmsqol @requires:nelim.pickletools.screenshotmode @requires:nelim.pickletools.loadaudit
Feature: Reading Bonus and Bookshelf: the hidden shortcut and the declared incompatibility

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    Then mod "MalteSchulze.RIMMSqol" is loaded
    And RIMMSQOL is ready to be driven

  Scenario: RIMMSQOL lists the shortcut, hidden, and the bar does not draw it
    Then RIMMSQOL's own list of main buttons offers "KTK_BookMod_Settings"
    And RIMMSQOL shows the main button "KTK_BookMod_Settings" as hidden
    And RIMMSQOL holds no choice for the main button "KTK_BookMod_Settings"
    And the main bar does not draw the button "KTK_BookMod_Settings"

  Scenario: revealed in RIMMSQOL the shortcut is drawn and opens the settings window, then it is forgotten
    When RIMMSQOL reveals the main button "KTK_BookMod_Settings"
    Then RIMMSQOL shows the main button "KTK_BookMod_Settings" as visible
    And the main bar draws the button "KTK_BookMod_Settings"
    When the main bar's button "KTK_BookMod_Settings" is activated
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "settings window opened by the shortcut RIMMSQOL revealed"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
    When RIMMSQOL forgets its choice for the main button "KTK_BookMod_Settings"
    Then RIMMSQOL holds no choice for the main button "KTK_BookMod_Settings"
    And the main bar does not draw the button "KTK_BookMod_Settings"
    And no errors were logged

  Scenario: the original Kutake mod is declared incompatible
    Then Nelim's Pickle Tools: the mod "nelim.readingbonusandbookshelf" declares itself incompatible with "Kutake.ReadingBoundsAndBookshelfPatch"
