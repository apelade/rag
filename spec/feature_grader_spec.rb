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
      feature_grader = FeatureGrader.new('', { spec: 'spec' })
      expect(feature_grader.instance_variable_get(:@output)).to eq([])
      expect(feature_grader.instance_variable_get(:@m_output)).to be_a(Mutex)
      expect(feature_grader.instance_variable_get(:@features)).to eq([])

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
      @mock_stdout = StringIO.new
      $stdout = @mock_stdout

      @feature_grader = FeatureGrader.new('', { spec: '' })
      @feature_grader.instance_variable_set(:@output, ['log_1', 'log_2'])
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
      expect(logfile.string).to include('log_1', 'log_2')
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


  describe 'loads a description' do
    before :each do
      scenario_matcher = double(FeatureGrader::ScenarioMatcher).as_null_object
      FeatureGrader::ScenarioMatcher.stub(new: scenario_matcher)

      @feature_grader = FeatureGrader.new('', spec: 'test.yml.file')

      @valid_specs = {
          "scenarios" => [{ "match" => "a regex", "desc" => "print-friendly literal of regex" }],

          "features" => [
              { "FEATURE" =>
                    "features/filter_movie_list.feature",
                "pass" => true,
                "weight" => 0.2,
                "if_pass" => [
                    { "FEATURE" =>
                          "features/filter_movie_list.feature",
                      "version" => 2,
                      "weight" => 0.075,
                      "desc" => "results = [G, PG-13] movies",
                      "failures" => [{ "match" => "the same regex", "desc" => "print-friendly literal of regex" }] }
                ]
              }
          ]
      }
      YAML.stub(load_file: @valid_specs)
    end

    it 'puts the grading_rules spec or description into an instance variable' do
      expect(@feature_grader.instance_variable_get(:@description)).to eq 'test.yml.file'
    end

    it 'loads a file with that name into a hash document' do
      #TODO YA we should put requirements on the structure of the file and hash resulting from its loading
      expect(YAML).to receive(:load_file).with('test.yml.file')
      @feature_grader.send(:load_description)
    end

    it 'raises Argument error if the input is bad' do
      #TODO YA we should assert the presence of scenarios and features
      YAML.stub(load_file: {})
      expect { @feature_grader.send(:load_description) }.to raise_error
    end

    describe 'builds an array of FeatureGrader objects by parsing the description file' do
      it 'creates a FeatureGrader object'

      it 'processes the document into an array of Feature objects with instance vars for Grader and sub-Features contained by if_pass' do
        @feature_grader.send(:load_description)

        features_array = @feature_grader.instance_variable_get(:@features)
        #expect(features_array).to eq []

        root_feature = features_array[0]
        expect(root_feature).to be_a FeatureGrader::Feature

        grader = root_feature.instance_variable_get(:@grader)
        expect(grader).to be_a FeatureGrader

        # if a general case passes, run more specific tests
        child_features = root_feature.instance_variable_get(:@if_pass)
        expect(child_features[0]).to be_a FeatureGrader::Feature

        # version is used as a feature flag in the solution code to change behavior
        expect(child_features[0].instance_variable_get(:@env)['version']).to eq '2'
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
