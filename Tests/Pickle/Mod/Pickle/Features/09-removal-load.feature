# F8, launch 2 of 2: the save of 08 loaded WITHOUT the mod (-ThenWithout). The save loads, the bookcase and its
# books remain, and the room falls back to the vanilla bonus (1.032 for four normal novels, derived in 02).
@requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.colonistrace @requires:nelim.pickletools.deffields @requires:nelim.pickletools.savesteps
Feature: Reading Bonus and Bookshelf: the same save without the mod (2 of 2)

  @timeout:300
  Scenario: the save loads without the mod, the bookcase remains and the bonus is vanilla
    Given the save "rbab-removal" is loaded
    Then Nelim's Pickle Tools: the storage building "Bookcase" at (72, 88) holds 4 things
    And Nelim's Pickle Tools: the room at (71, 86) has the stat "ReadingBonus" at 1.032
