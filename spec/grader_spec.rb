require 'spec_helper'

describe 'Command Line Interface' do
  it 'should exist' do
    expect(Grader).not_to be_nil
  end
  it 'should define a cli method' do
    lambda { Grader.cli }.should_not raise_error(::NoMethodError)
  end
  it 'should display help when args are not appropriate' do
    expect(Grader.cli(['something'])).to eq Grader.help
  end
  describe 'should produce appropriate response to WeightedRspecGrader arguments' do
    it 'with correct args' do
      cli_args = ['-t','WeightedRspecGrader','correct_example.rb','correct_example.spec.rb']
      grd_args = ['1', 'WeightedRspecGrader','some code',{:spec => 'correct_example.spec.rb'}]
      IO.should_receive(:read).with('correct_example.rb').and_return('some code')
      execute cli_args, grd_args
    end
  end
  it 'should be able to handle passing in a github username' do
    cli_args = ['-t','GithubRspecGrader','tansaku','github_spec.rb']
    grd_args = ['1', 'GithubRspecGrader','tansaku',{:spec => 'github_spec.rb'}]
    execute cli_args, grd_args
  end
  it 'should be able to handle feature grader arguments' do
    cli_args = ['-t','HW3Grader','-a','/tmp/','features.tar.gz','hwz.yml']
    grd_args = ['3', 'HW3Grader','features.tar.gz',{:spec => 'hwz.yml'}]
    Kernel.should_receive(:const_get).with('HW3Grader').and_return(HW3Grader)
    HW3Grader.should_receive(:format_cli).with(cli_args).and_return(grd_args)
    execute cli_args, grd_args
  end
  it 'should be able to handle heroku grader arguments' do
    spec_file = 'hw5specs.rb'
    grading_rules = {:admin_user => 'admin', :admin_pass => 'password', :spec => spec_file}
    uri = 'myname.herokuapp.com'
    cli_args = ['-t','HW5Grader',uri,'admin','password',spec_file]
    grd_args = ['1', 'HW5Grader',uri,grading_rules]
    execute cli_args, grd_args
  end
  xit 'should be able to receive different arguments depending on the grader specified' do
    #HW4 e.g. new_grader -t HW4Grader input.tar.gz description.yml
  end
  @MOCK_RESULTS = 'MOCK_RESULTS'
  def mock_auto_grader
    auto_grader = double('AutoGrader')
    auto_grader.should_receive(:grade!)
    auto_grader.should_receive(:normalized_score).with(100).and_return(67)
    auto_grader.should_receive(:comments).and_return(@MOCK_RESULTS)
    return auto_grader
  end
  def execute(cli_args, grader_args)
    AutoGrader.should_receive(:create).with(*grader_args).and_return(mock_auto_grader)
    grader = Grader.cli cli_args
    expect(grader).to match /#{@MOCK_RESULTS}/
  end
end
