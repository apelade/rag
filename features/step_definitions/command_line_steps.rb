
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


Given(/^several needed gems are available/) do
  ['rails',
   'rspec-rails',
   'sqlite3',
   'cucumber',
   'cucumber-rails',
   'haml-rails',
   'database_cleaner'
  ].each{ | gem |
    output = `sudo gem list #{gem}`
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

And(/^not a bunch of errors/) do
  @hw4_result.should_not match 'Error'
end


