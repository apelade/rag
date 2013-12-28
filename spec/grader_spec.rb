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
    grd_args = ['1', 'WeightedRspecGrader','some code',{:spec => 'correct_example.spec.rb'}]
    IO.should_receive(:read).with('correct_example.rb').and_return('some code')
    execute cli_args, grd_args
  end
  xit 'should capture needed itegration for weighted rspec grader cli' do
    begin
      cur_dir = Dir.getwd
      FileUtils.cp cur_dir+'/spec/fixtures/correct_example.rb', cur_dir
      FileUtils.cp cur_dir+'/spec/fixtures/correct_example.spec.rb', cur_dir
      cli_args = ['-t','WeightedRspecGrader','correct_example.rb','correct_example.spec.rb']
      grader = Grader.cli cli_args
      expect(grader).to eq Grader.help
    end
  end
  it 'should be able to handle passing in a github username' do
    cli_args = ['-t','GithubRspecGrader','tansaku','github_spec.rb']
    grd_args = ['1', 'GithubRspecGrader','tansaku',{:spec => 'github_spec.rb'}]
    execute cli_args, grd_args
  end
  xit 'should capture needed itegration for github grader cli' do
  end
  it 'should be able to handle feature grader arguments' do
    cli_args = ['-t','HW3Grader','-a','/tmp/','features.tar.gz','hwz.yml']
    grd_args = ['3', 'HW3Grader','features.tar.gz',{:spec => 'hwz.yml'}]
    Kernel.should_receive(:const_get).with('HW3Grader').and_return(HW3Grader)
    HW3Grader.should_receive(:format_cli).with(cli_args).and_return(grd_args)
    execute cli_args, grd_args
  end
  it 'should capture needed itegration for feature grader cli' do
    FileUtils.cp Dir.getwd+'/spec/fixtures/features.tar.gz', '/tmp'
    FileUtils.cp Dir.getwd+'/spec/fixtures/hwz.yml', '/tmp'
    cli_args = ['-t','HW3Grader','-a','/tmp/','features.tar.gz','hwz.yml']
    grader = Grader.cli cli_args
    expect(grader).to match /^(Normalized )?Score out of 100:/
  end
  it 'should be able to handle heroku grader arguments' do
    spec_file = 'hw5specs.rb'
    grading_rules = {:admin_user => 'admin', :admin_pass => 'password', :spec => spec_file}
    uri = 'myname.herokuapp.com'
    cli_args = ['-t','HW5Grader',uri,'admin','password',spec_file]
    grd_args = ['5', 'HW5Grader',uri,grading_rules]
    execute cli_args, grd_args
  end
  xit 'should capture needed integration for heroku grader cli' do
    uri = 'myname.herokuapp.com'
    spec_file = 'hw5specs.rb'
    cli_args = ['-t','HW5Grader',uri,'admin','password',spec_file]
    grader = Grader.cli cli_args
    expect(grader).to eq Grader.help
  end
  it 'should be able to accept a HW4Grader project and report results' do
    cli_args = ['-t','HW4Grader','input.tar.gz', 'hw4.yml']
    grd_args = [ '4','HW4Grader','input.tar.gz', {:description => 'hw4.yml'}]
    execute cli_args, grd_args
  end
  # This slow integration test adds 10% coverage, requires Gemfile changes and a valid tar file in rag/spec/fixtures
  xit 'should also report results from HW4Grader when not stubbed out' do
    begin
      cur_dir = Dir.getwd
      FileUtils.cp cur_dir+'/spec/fixtures/hw4_sample_input.tar.gz', cur_dir
      cli_args = ['-t','HW4Grader','hw4_sample_input.tar.gz', 'hw4.yml']
      grader = Grader.cli cli_args
      expect(grader).to match /Total score:/
    ensure
      FileUtils.rm cur_dir+'/hw4_sample_input.tar.gz'
    end
  end
  @MOCK_RESULTS = 'MOCK_RESULTS'
  def mock_auto_grader
    auto_grader = double('AutoGrader')
    auto_grader.should_receive(:grade!)
    auto_grader.should_receive(:normalized_score).with(100).and_return(67)
    auto_grader.should_receive(:comments).and_return(@MOCK_RESULTS)
    return auto_grader
  end
  def execute(cli_args, grader_args, expected=/#{@MOCK_RESULTS}/)
    AutoGrader.should_receive(:create).with(*grader_args).and_return(mock_auto_grader)
    grader = Grader.cli cli_args
    expect(grader).to match expected
    return grader
  end
end
