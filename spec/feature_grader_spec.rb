require 'spec_helper'

describe FeatureGrader do

  before(:each) do
    File.stub(file?: true, readable?: true)
    @temp_file = double(TempArchiveFile).as_null_object
    TempArchiveFile.stub(new: @temp_file)
  end

  it 'sets the path for cuke_runnner script' do
    expect(File).to exist($CUKE_RUNNER)
  end

  describe '#initialize' do

    it 'initializes instance variables' do
      feature_grader = FeatureGrader.new('features_archive', { spec: 'test.yml.file' })
      expect(feature_grader.instance_variable_get(:@output)).to eq([])
      expect(feature_grader.instance_variable_get(:@m_output)).to be_a(Mutex)
      expect(feature_grader.instance_variable_get(:@features)).to eq([])

      expect(feature_grader.instance_variable_get(:@features_archive)).to eq 'features_archive'
      expect(feature_grader.instance_variable_get(:@description)).to eq 'test.yml.file'

    end
    it 'raises error if no features file' do
      allow(File).to receive(:file?).with('foo').and_return false
      expect { FeatureGrader.new('foo', '') }.to raise_error(Exception, /Unable to find features archive/)
    end

    it 'raises error if no description file' do
      allow(File).to receive(:file?).with('spec').and_return(false)
      expect { FeatureGrader.new('', { spec: 'spec' }) }.to raise_error(Exception, /Unable to find description file/)
    end

    it 'creates a temporary feature file' do
      expect(TempArchiveFile).to receive(:new).with('features').and_return(@temp_file)
      feature_grader = FeatureGrader.new('features', { spec: '' })
      expect(feature_grader.instance_variable_get(:@temp)).to eq(@temp_file)
    end

    it 'sets a log path' do
      temp_file = double(TempArchiveFile, path: 'temp_path')
      TempArchiveFile.stub(new: temp_file)

      feature_grader = FeatureGrader.new('features', { spec: '' })
      expect(feature_grader.instance_variable_get(:@logpath)).not_to be_nil
      expect(feature_grader.instance_variable_get(:@logpath)).to match(/temp_path\.log/)
    end
  end

  it '#log outputs into log instance variable' do
    feature_grader = FeatureGrader.new('', { spec: '' })
    feature_grader.log('log_1', 'log_2')
    expect(feature_grader.instance_variable_get(:@output)).to include('log_1', 'log_2')
  end

  describe '#dump_output' do
    before(:each) do
      $VERBOSE = nil #suppresing warnings when reassigning constants
      @old_stdout = STDOUT
      @mock_stdout = StringIO.new
      STDOUT = @mock_stdout

      @feature_grader = FeatureGrader.new('', { spec: '' })
      @feature_grader.instance_variable_set(:@output, ['log_1', 'log_2'])
    end

    after(:each) do
      STDOUT = @old_stdout
    end

    it 'stores output in comments' do
      @feature_grader.dump_output
      expect(@feature_grader.comments).to include('log_1', 'log_2')
    end

    it 'writes output to stdout' do
      @feature_grader.dump_output
      expect(@mock_stdout.string).to include('log_1', 'log_2')
    end

    it 'writes output to logfile' do
      logfile = StringIO.new
      @feature_grader.instance_variable_set(:@logpath, 'logpath')
      expect(File).to receive(:open).with('logpath', 'a').and_return(logfile)

      @feature_grader.dump_output
      #need to do minor change to source to assert this
      #expect(logfile.string).to include('log_1', 'log_2')
    end

    describe '#grade' do

      before :each do
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

        Time.stub(now: 24)
        score = double('Total', points: 5, max: '5')
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

  describe '#load_description' do
    before(:each) do
      scenario_matcher = double(FeatureGrader::ScenarioMatcher).as_null_object
      FeatureGrader::ScenarioMatcher.stub(new: scenario_matcher)

      @feature = double(FeatureGrader::Feature).as_null_object
      FeatureGrader::Feature.stub(new: @feature)

      @feature_grader = FeatureGrader.new('', spec: 'test.yml.file')
      @fixture_spec = YAML.load_file('spec/fixtures/feature_grader.yml')
      # the spec gets modified during processing, so we keep a reference spec separately
      spec = YAML.load_file('spec/fixtures/feature_grader.yml')
      YAML.stub(load_file: spec)
    end

    it 'loads the description file with YAML' do
      expect(YAML).to receive(:load_file).with('test.yml.file')
      @feature_grader.send(:load_description)
    end

    it 'validates the parsed yml file' do
      #TODO YA more validations should be added to code
      valid_specs = { 'features' => [], 'scenarios' => [] }
      YAML.stub(load_file: valid_specs)

      @feature_grader.send(:load_description)
    end

    it "raises an error if 'scenarios' key is not present in yml file" do
      invalid_specs = { 'features' => [] }
      YAML.stub(load_file: invalid_specs)

      expect { @feature_grader.send(:load_description) }.to raise_error
    end

    it "raises an error if 'features' key is not present in yml file" do
      invalid_specs = { 'scenarios' => [] }
      YAML.stub(load_file: invalid_specs)

      expect { @feature_grader.send(:load_description) }.to raise_error
    end

    describe 'builds an array of Feature objects by parsing the description file' do

      it 'builds an array of Feature objects' do
        @feature_grader.send(:load_description)
        expect(@feature_grader.instance_variable_get(:@features)).to be_an(Array)
        expect(@feature_grader.instance_variable_get(:@features)).to have(@fixture_spec['features'].count).feature_obects
      end

      it 'Feature objects have nested if_pass array of Feature' do
        FeatureGrader::ScenarioMatcher.stub(:new).and_call_original
        FeatureGrader::Feature.stub(:new).and_call_original
        @feature_grader.send(:load_description)

        feature = @feature_grader.instance_variable_get(:@features)[0]
        expect(feature.if_pass).to be_an(Array)

        correct_number = @fixture_spec['features'][0]['if_pass'].count
        expect(feature.if_pass).to have(correct_number).feature_objects

        expect(feature.if_pass[0]).to be_a(FeatureGrader::Feature)
      end

      it 'Feature objects have nested failures array of ScenarioMatchers' do
        FeatureGrader::ScenarioMatcher.stub(:new).and_call_original
        FeatureGrader::Feature.stub(:new).and_call_original
        @feature_grader.send(:load_description)

        if_pass_feature = @feature_grader.instance_variable_get(:@features)[0].if_pass[0]
        expect(if_pass_feature.failures).to be_an(Array)

        correct_number = @fixture_spec['features'][0]['if_pass'][0]['failures'].count
        expect(if_pass_feature.failures).to have(correct_number).scenario_matcher_objects

        expect(if_pass_feature.failures[0]).to be_a(FeatureGrader::ScenarioMatcher)
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
