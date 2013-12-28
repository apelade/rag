Feature: Command line grader
  As a maintainer of the system
  So that I can avoid untested scripts
  I want all graders to be runnable through a single lightweight script

  Scenario: Simple Script
    When I run a WeightedRspecGrader
    Then it should have the expected output

  # Scenario: Descriptive Script
  #   Given (precondition)
  #    When (action)
  #    Then (expectation)
  Scenario: Archive Script
    Given arguments '-t','HW4Grader','input.tar.gz', 'hw4.yml'
     When the script is run with environment settings and resources
     Then my eyes will be blessed with 'Test Data'
  cli_args = []
  grd_args = [ '4','HW4Grader','input.tar.gz', {:description => 'hw4.yml'}]
  execute cli_args, grd_args
  end
