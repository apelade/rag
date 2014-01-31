def run_in_reference_dir(cli_arg_string)
  @test_output, @test_errors, @test_status = Open3.capture3(
      { 'BUNDLE_GEMFILE' => 'Gemfile' }, cli_arg_string, :chdir => @reference_app_path
  )
end

# GIVEN STEPS

Given /^I have a reference application$/ do
  @homeworks_hw3_path       = 'homeworks/HW3'
  @submitted_path           = "#{@homeworks_hw3_path}/submitted"
  @reference_app_path       = "#{@homeworks_hw3_path}/app"
  @reference_solution_path  = "#{@homeworks_hw3_path}/solution"
  @config_file_path = File.join(@reference_app_path, '/config', 'autograder_config.yml')
end

When /^I submit the reference solution archive with all correct answers$/ do
  @student_features_path = "#{@reference_solution_path}/features.tar.gz"
end

Given(/^I have the student submission cucumber features file$/) do
  @student_features_path = "#{@submitted_path}/features.tar.gz"
end

# WHEN STEPS
When(/^I run the homework deploy script$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the reference application should be present$/) do
  expect(Dir).to exist(@reference_app_path)
end

When(/^I run the AutoGrader with FeatureGrader strategy$/) do
  cli_string = "./grade3 -a #{@reference_app_path} #{@student_features_path} #{@config_file_path}"
  @test_output, @test_errors, @test_status = Open3.capture3(cli_string)
end

When /^I run rspec tests on reference application$/ do
  run_in_reference_dir('bundle exec rspec --no-color')
end

When /^I run cucumber tests on reference application$/ do
  run_in_reference_dir('bundle exec cucumber --no-color --no-profile')
end

When /^I run cucumber tests for mutations$/ do
  run_in_reference_dir('bundle exec cucumber --no-color --no-profile')
end

# THEN STEPS

Then /^I should see the tests execute correctly$/ do
  # rspec and cucumber set exit status to 1 if there any fails, otherwise to 0
  expect(@test_status).to be_success
end

Then /^I should see test results$/ do
  # for debugging
  puts @test_output
  puts @test_errors
  puts @test_status
end

Then /^I should have the autograder_config.yml file for the reference application$/ do
#  the configuration file should reside in config folder of reference application
  expect(File).to exist(@config_file_path)
end

Then /^autograder_config.yml file should validate successfully$/ do
  expect {YAML::load_file(@config_file_path)}.not_to raise_error
end

Then /^I should yml loading errors$/ do
  # for debugging
  begin
    config_file = YAML::load_file(@config_file_path)
  rescue Psych::SyntaxError => error
    puts error.message
  end

end

And /^I should see the successful output from AutoGrader$/ do
  #from AutoGraderSubprocess
  SCORE_REGEX = /Score out of \d+:\s*(\d+(?:\.\d+)?)$/
  COMMENT_REGEX = /---BEGIN (?:cucumber|rspec|grader) comments---\n#{'-'*80}\n(.*)#{'-'*80}\n---END (?:cucumber|rspec|grader) comments---/m
  expect(@test_output).to match SCORE_REGEX
  expect(@test_output).to match COMMENT_REGEX
end

And /^I should see the normalized score equals (.*)$/ do |score|
  expect(score.to_f).to be >= 0
  expect(score.to_f).to be <= 1.0
  expect(@test_output).to include "Total score: #{score} / 1.0"
end


