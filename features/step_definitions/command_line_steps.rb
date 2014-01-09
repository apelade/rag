
Given(/^a script with class Grader with a method cli/) do
  Grader.should respond_to :cli
end

Given(/^command line arguments are invalid/) do
  @args = "clearly invalid arguments"
end

When(/^I run the script with the arguments/) do
  @result = Grader.cli @args
end

Then(/^the results should be the help/) do
  @result.should eql Grader.help
end


#################################################################


Given(/^I have several needed gems available$/) do
  ['rails',
   'rspec-rails',
   'sqlite3',
   'cucumber',
   'cucumber-rails',
   'haml-rails',
   'database_cleaner'
  ].each{ | gem |
    output = `gem list #{gem}`
    expect(output.delete("\n")).to match /#{gem}\s/
  }
end

Given(/^a valid tar file named hw4_sample_input.tar.gz in .\/spec\/fixtures\/ copied to current dir/) do
  expect(File.file? './spec/fixtures/hw4_sample_input.tar.gz').to eq true
  FileUtils.cp './spec/fixtures/hw4_sample_input.tar.gz', './'
  expect(File.file? './hw4_sample_input.tar.gz').to eq true
end

Given(/^a valid yml file named hw4.yml in current dir/) do
  expect(File.file? './hw4.yml').to eq true
end

Given(/^command line arguments of "(.*?)"/) do |cli_arg_string|
  @hw4_args = cli_arg_string.split ' '
end

When(/^I run Grader\.cli with the arguments/) do
  @hw4_result = Grader.cli @hw4_args
end

Then(/^I should see "(.*?)"/) do |arg1|
  @hw4_result.should match arg1
end

And(/^I should not see "Error"/) do
  @hw4_result.should_not match 'Error'
end


#################################################################


Given(/^the HW3 background is complete$/) do
# Make a test feature archive and dirs or depend on cuke to do it. Fixture?
 cucumber_code = "Feature: feature\n  Scenario: Test\n    Given OK"
 cucumber_steps= "Given /^OK/ do\n  true\nend"
 mutation_yml  = 'hwz.yml'
 FileUtils.mkdir_p '/tmp/log'
 FileUtils.mkdir_p '/tmp/db'
 FileUtils.mkdir_p '/tmp/features/step_definitions'
 FileUtils.touch '/tmp/db/test.sqlite3'
 FileUtils.cp "#{Dir::getwd}/#{mutation_yml}", '/tmp'
 File.open('/tmp/features/test.feature','w') do |file|
   file.write cucumber_code
 end
 File.open('/tmp/features/step_definitions/test_steps.rb','w') do |file|
   file.write cucumber_steps
 end
 expect{
   tar_output = %x{'tar czf /tmp/features.tar.gz -C /tmp/ features/'}
 }.not_to raise_error
end

When(/^I run a HW3Grader/) do
  args = ['-t', 'WeightedRspecGrader','spec/fixtures/correct_example.rb','spec/fixtures/correct_example.spec.rb']
  @hw3_output = Grader.cli(args)
end

Then(/^HW3 should have the expected output$/) do
  @hw3_output.should =~ /Score out of 100: 0/
  @hw3_output.should =~ /BEGIN rspec comments/
  @hw3_output.should =~ /1 example, 0 failures/

   #lacks 'END cucumber comments' if /tmp/log/ not exist
end


#################################################################


When(/^I run a WeightedRspecGrader$/) do
  # equivalent to ./new_grader -t WeightedRspecGrader spec/fixtures/correct_example.rb spec/fixtures/correct_example.spec.rb
  args = ['-t', 'WeightedRspecGrader','spec/fixtures/correct_example.rb','spec/fixtures/correct_example.spec.rb']
  @cli_output = Grader.cli(args)
end

Then(/^it should have the expected output$/) do
  @cli_output.should =~ AutoGraderSubprocess::COMMENT_REGEX
end


#################################################################

# HW 2, 5, Github, migration

   
