Feature: FeatureGrader
  In order to check that students are capable of writing acceptance tests with cucumber
  As an instructor
  I want to grade and provide feedback on their cucumber features, scenarios and step definitions

  #TODO YA the current reference application is based on 169.1 HW3 assignment, thus we cannot keep it within
  #this repo in spec/fixtures. Instead, we are pulling it from a private repo and setting it up
  Background:
    Given I have a reference application

#HAPPY SCENARIOS
  Scenario: Reference application and solutions are present
    #TODO YA implement later: Reference application and solutions are pulled in from a private repo
    When I run the homework deploy script
    Then the reference application should be present

  Scenario: Reference application is properly set-up (rspec)
    When I run rspec tests on reference application
    Then I should see the tests execute correctly

  Scenario: Reference application is properly set-up (cucumber)
    When I run cucumber tests on reference application
    Then I should see the tests execute correctly

  Scenario: Homeworks config.yml is present
    Then I should have the autograder_config.yml file for the reference application
    And autograder_config.yml file should validate successfully

  Scenario: FeatureGrader strategy is available and is properly set-up for current AutoGrader
    Given I have the student submission cucumber features file
    When I run the AutoGrader with FeatureGrader strategy
    Then I should see the tests execute correctly
    And I should see the successful output from AutoGrader

  # Slow, combine with above? 49.5% reference solution?
  Scenario: FeatureGraders grades 100% when a reference solution is submitted
    Given I submit the reference solution archive with all correct answers
    When I run the AutoGrader with FeatureGrader strategy
    Then I should see the normalized score equals 1.0

#  Scenario: FeatureGrader gives correct scores
#  Scenario: FeatureGrader provides feedback


#TODO YA implement later: this test is for instructor tool set, so that he can check that his reference app
# before deploying the config to rag server

#  Scenario: Mutations for reference app are present and working properly
#    When I run cucumber tests for mutations
#    Then I should have the autograder_config.yml file for the reference application



