# F11 and the slider tooltips. Played once per language (-Language French, then ChineseSimplified): the settings
# window, then the tooltip of a quality slider, each captured for the review. No raw key must be drawn.
@review @requires:nelim.pickletools.screenshotmode @requires:nelim.pickletools.hoversteps @requires:nelim.pickletools.colonistrace
Feature: Reading Bonus and Bookshelf: the settings window and its tooltips in the active language

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  @timeout:300
  Scenario: the settings window shows no raw key and its slider tooltip is drawn
    When Nelim's Pickle Tools: I open the mod options page of the mod "nelim.readingbonusandbookshelf"
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "settings window in the active language"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And Nelim's Pickle Tools: I hover over the tooltip keyed "KTK_BookMod_bounsTip"
    Then Nelim's Pickle Tools: the tooltip keyed "KTK_BookMod_bounsTip" is drawn
    When I take a screenshot "slider tooltip in the active language"
    And Nelim's Pickle Tools: I close the mod options window
    Then no errors were logged
