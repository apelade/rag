require 'spec_helper'


describe FeatureGrader do
  it 'sets the path for cuke_runnner script' do
    expect(File).to exist($CUKE_RUNNER)
  end

  describe '#initialize' do
    it 'initializes instance variables' do
      File.stub(file?: true, readable?: true)
      temp_file = double(TempArchiveFile, path: '')
      TempArchiveFile.stub(new: temp_file)

      feature_grader = FeatureGrader.new('', { spec: 'spec' })
      expect(feature_grader.instance_variable_get(:@output)).to eq([])
      expect(feature_grader.instance_variable_get(:@m_output)).to be_a(Mutex)
      expect(feature_grader.instance_variable_get(:@features)).to eq([])

    end
    it 'raises error if no features file' do
      File.should_receive(:file?).with('foo').and_return false
      expect { FeatureGrader.new('foo', '') }.to raise_error(Exception, /Unable to find features archive/)
    end

    it 'raises error if no description file' do
      File.stub(file?: true, readable?: true)

      allow(File).to receive(:file?).with('spec').and_return(false)
      expect { FeatureGrader.new('', { spec: 'spec' }) }.to raise_error(Exception, /Unable to find description file/)
    end

    it 'creates a temporary feature file' do
      temp_file = double(TempArchiveFile).as_null_object
      expect(TempArchiveFile).to receive(:new).with('features').and_return(temp_file)

      File.stub(file?: true, readable?: true)
      feature_grader = FeatureGrader.new('features', { spec: '' })

      expect(feature_grader.instance_variable_get(:@temp)).to eq(temp_file)
    end

    it 'sets a log path' do
      temp_file = double(TempArchiveFile, path: 'temp_path')
      TempArchiveFile.stub(new: temp_file)

      File.stub(file?: true, readable?: true)

      feature_grader = FeatureGrader.new('features', { spec: '' })
      expect(feature_grader.instance_variable_get(:@logpath)).not_to be_nil
      expect(feature_grader.instance_variable_get(:@logpath)).to match(/temp_path\.log/)
    end

    it '#outputs into log instance variable' do
      File.stub(file?: true, readable?: true)

      temp_file = double(TempArchiveFile, path: '')
      TempArchiveFile.stub(new: temp_file)

      feature_grader = FeatureGrader.new('', { spec: '' })
      feature_grader.log('log_1', 'log_2')
      expect(feature_grader.instance_variable_get(:@output)).to include('log_1', 'log_2')
    end

    describe '#grade' do

      before :each do
        File.stub(file?: true, readable?: true)
        @temp_file = double(TempArchiveFile).as_null_object
        TempArchiveFile.stub(new: @temp_file)
        @feature_grader = FeatureGrader.new('', { spec: '' })
        @feature_grader.stub(:load_description)
      end

      it 'sets environment variable' do
        @feature_grader.grade!
        expect(ENV['RAILS_ENV']).to eq 'test'
      end

      it 'grades the homework' do
        allow(@feature_grader).to receive(:grade!).and_call_original
        expect(@feature_grader).to receive(:load_description)
        @feature_grader.grade!
      end

      it 'creates a score' do
        @feature_grader.instance_variable_set(:@features, 555)
        score = double('Total', points: 5, max: '5')
        Time.stub(now: 24)
        FeatureGrader::Feature.stub(total: score)
        expect(@feature_grader).to receive(:log).with("Total score: 5 / 5")
        expect(@feature_grader).to receive(:log).with("Completed in 0 seconds.")
        @feature_grader.grade!
      end

      it 'deletes the temp archive when finished' do
        @feature_grader.instance_variable_set(:@temp, @temp_file)
        expect(@temp_file).to receive :destroy
        @feature_grader.grade!
      end
    end

  end



  describe FeatureGrader::ScenarioMatcher do
    before :each do
      @test_config = 'test_config'
      @hash = { "match" => 'cucumber_output' }
      @scenario_matcher = FeatureGrader::ScenarioMatcher.new('grader', @hash, @test_config)
    end
    it '#initialize' do
      expect(@scenario_matcher.instance_variable_get :@config).to eq(@test_config)
      expect(@scenario_matcher.desc).to eq(@hash['match'])
      expect(@scenario_matcher.regex).to eq(/cucumber_output/)
    end
    it 'raises ArgumentError when match argument is empty' do
      expect { FeatureGrader::ScenarioMatcher.new('grader', '', @test_config) }.to raise_error
    end

    it '#match?' do
      expect(@scenario_matcher.match?(@hash['match'])).to be_true
    end
    it '#present_on?' do
      expect(@scenario_matcher.present_on?("Scenario: #{@hash['match']}")).to be_true
    end
    it '#to_s' do
      expect(@scenario_matcher.to_s).to eq @hash['match']
    end
  end


end
