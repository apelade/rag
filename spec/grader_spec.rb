require 'spec_helper'

describe 'Command Line Interface' do
  it 'should exist' do
    expect(Grader).not_to be_nil
  end
  it 'should define a cli method' do
    expect(Grader).to respond_to :cli
  end
  it 'should display help when args are not appropriate' do
    expect(Grader.cli(['something'])).to eq Grader.help
  end
  it 'should produce appropriate response to WeightedRspecGrader arguments' do
    cli_args = ['-t','WeightedRspecGrader','correct_example.rb','correct_example.spec.rb']
    grd_args = ['Weighted ID','WeightedRspecGrader','some code',{:spec => 'correct_example.spec.rb'}]
    IO.should_receive(:read).with('correct_example.rb').and_return('some code')
    execute cli_args, grd_args
  end
  it 'should be able to handle passing in a github username' do
    cli_args = ['-t','GithubRspecGrader','tansaku','github_spec.rb']
    grd_args = ['Github ID','GithubRspecGrader','tansaku',{:spec => 'github_spec.rb'}]
    execute cli_args, grd_args
  end
  it 'should be able to handle heroku grader arguments' do
    spec_file = 'hw5specs.rb'
    grading_rules = {:admin_user => 'admin', :admin_pass => 'password', :spec => spec_file}
    uri = 'myname.herokuapp.com'
    cli_args = ['-t','HW5Grader',uri,'admin','password',spec_file]
    grd_args = ['5', 'HW5Grader',uri,grading_rules]
    execute cli_args, grd_args
  end
  it 'should be able to accept a HW4Grader project and report results' do
    cli_args = ['-t','HW4Grader','input.tar.gz', 'hw4.yml']
    grd_args = [ '4','HW4Grader','input.tar.gz', {:description => 'hw4.yml'}]
    execute cli_args, grd_args
  end
  it 'should be able to handle feature grader arguments' do
    cli_args = ['-t','HW3Grader','-a','/tmp/','features.tar.gz','hwz.yml']
    grd_args = ['3', 'HW3Grader','features.tar.gz',{:spec => 'hwz.yml'}]
    execute cli_args, grd_args
  end
  def execute(cli_args, grd_args, expected=/#{@MOCK_RESULTS}/)
    set_common_expectations cli_args, grd_args
    grader = Grader.cli cli_args
    expect(grader).to match expected
    return grader
  end
  def set_common_expectations(cli_args, grd_args)
    type = cli_args[1]
    ag_class = Kernel.const_get type
    expect  {ag_class.format_cli(*cli_args).to match_array grd_args}.to be_true
    expect(ag_class).to receive(:format_cli).with(*cli_args).and_call_original
    expect(AutoGrader).to receive(:create).with(*grd_args).and_return(mock_auto_grader)
  end
  @MOCK_RESULTS = 'MOCK_RESULTS'
  def mock_auto_grader
    auto_grader = double('AutoGrader')
    auto_grader.should_receive(:grade!)
    auto_grader.should_receive(:normalized_score).with(100).and_return(67)
    auto_grader.should_receive(:comments).and_return(@MOCK_RESULTS)
    return auto_grader
  end
end
