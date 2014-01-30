require 'spec_helper'


describe FeatureGrader do
  it 'sets the path for cuke_runnner script' do
    expect(File).to exist($CUKE_RUNNER)
  end

  it '#new', pending do
  end

  describe FeatureGrader::ScenarioMatcher do
    before :each do
      @test_config = 'test_config'
      @hash = {"match" => 'cucumber_output'}
      @scenario_matcher = FeatureGrader::ScenarioMatcher.new('grader', @hash, @test_config)
    end
    it '#initialize' do
      expect(@scenario_matcher.instance_variable_get :@config).to eq(@test_config)
      expect(@scenario_matcher.desc).to eq(@hash['match'])
      expect(@scenario_matcher.regex).to eq(/cucumber_output/)
    end
    it 'raises ArgumentError when match argument is empty' do
      expect {FeatureGrader::ScenarioMatcher.new('grader', '', @test_config)}.to raise_error
    end

    it '#match?' do
      expect(@scenario_matcher.match?('cucumber_output')).to be_true
    end
    it '#present_on?' do
      expect(@scenario_matcher.present_on?("Scenario: #{@hash['match']}")).to be_true
    end
    it '#to_s' do
      expect(@scenario_matcher.desc).to eq @hash['match']
    end
  end

end





#  describe '#new' do
#    it "should give error if it cannot find the features archive file" do
#      File.should_receive(:file?).with('foo').and_return false
#      lambda { FeatureGrader.new('foo', {}) }.should raise_error ArgumentError, /features/
#    end
#    it "should give error if it cannot find the description file" do
#      File.should_receive(:file?).with('foo').and_return true
#      File.should_receive(:readable?).with('foo').and_return true
#      File.should_receive(:file?).with('none.yml').and_return false
#      lambda { FeatureGrader.new('foo', {:description => 'none.yml'}) }.should raise_error ArgumentError, /description/
#    end
#    it "sets up a log path" do
#      TempArchiveFile.stub(:new).and_return(double("path", :path=>"/tmp"))
#      File.should_receive(:file?).with('foo').and_return true
#      File.should_receive(:readable?).with('foo').and_return true
#      File.should_receive(:file?).with('hw3.yml').and_return true
#      File.should_receive(:readable?).with('hw3.yml').and_return true
#      expect(FeatureGrader.new('foo', {:description => 'hw3.yml'}).logpath).not_to be_nil
#    end
#
#    it 'sets the path for cuke_runnner script' do
#      expect(File).to exist($CUKE_RUNNER)
#    end
#
#  end
#end
