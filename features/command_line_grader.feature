Feature: Command line grader
  As a maintainer of the system
  So that I can avoid untested scripts
  I want all graders to be runnable through a single lightweight script

  Scenario: Invalid arguments
    Given a script with class Grader with a method cli
    Given command line arguments are invalid arguments
     When I run the script with the arguments
     Then the results should be the help information
  
  #Scenario: Run passing Feature Grader homework
  #  Given I have several needed gems available
  #  Given a valid tar file named hw4_sample_input.tar.gz in ./spec/fixtures/ copied to current dir
  #  Given a valid yml file named hw4.yml in current dir
  #  Given command line arguments of "-t HW4Grader hw4_sample_input.tar.gz hw4.yml"
  #   When I run Grader.cli with the arguments
  #   Then I should see "Total score:"

  Scenario: Run passing WeightedRspecGrader homework
    When I run a WeightedRspecGrader
    Then it should have the expected output

  Scenario: Run passing HW3
    Given the HW3 background is complete
     When I run a HW3Grader
     Then HW3 should have the expected output
