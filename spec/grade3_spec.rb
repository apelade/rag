require 'spec_helper'

describe 'grade3' do
  let(:grader) { './grade3' }

  before(:each) do
    @root_path = Dir::getwd
    @reference_application_folder = File.expand_path('test.app')
    @feature_file = File.expand_path('test.feature')
    @config_file = File.expand_path('test.yml')
    ARGV.replace %W(-a #{@reference_application_folder} test.feature test.yml)

    @auto_grader = double(AutoGrader, :normalized_score => 1000, :comments => 'test').as_null_object
    AutoGrader.stub(:create).and_return(@auto_grader)

    Dir.stub(:chdir)

    @mock_stdout = StringIO.new
    $stdout = @mock_stdout
  end

  describe 'validating command line invocation' do

    it 'prints out usage information when no parameters are passed' do
      ARGV.replace %W()
      expect{ load grader }.to raise_error
      expect(@mock_stdout.string).to include('Usage:')
    end
    it 'prints out usage information when wrong number parameters are passed' do
      ARGV.replace %W(-a test.feature)
      expect{ load grader }.to raise_error
      expect(@mock_stdout.string).to include('Usage:')
    end

    it 'prints out usage information when reference application path is not passed' do
      ARGV.replace %W(test.feature test.yml)
      expect{ load grader }.to raise_error
      expect(@mock_stdout.string).to include('Usage:')
    end
  end
  describe 'setting environment' do
    it 'changes the working directory to the reference application root' do
      expect(Dir).to receive(:chdir).with(@reference_application_folder)
      load grader
    end
    it 'sets the environment variable RAILS_ROOT to reference_application_root' do
      Dir.stub(:getwd).and_return(@reference_application_folder)
      load grader
      expect(ENV['RAILS_ROOT']).to eq(@reference_application_folder)
    end
    it 'initializes AutoGrader with correct parameters' do
      expect(AutoGrader).to receive(:create) do |arg_1, arg_2, arg_3, arg_4|
        expect(arg_1).to eq('3')
        expect(arg_2).to eq('HW3Grader')
        expect(arg_3).to eq(@feature_file)
        expect(arg_4[:description]).to eq(@config_file)
        @auto_grader # return @autograder double defined in before(:each) block
      end
      load grader
    end
    it 'changes back to root directory' do
      load grader
      expect(Dir::getwd).to eq(@root_path)
    end
  end
  describe 'running AutoGrader' do
    it 'runs AutoGrader' do
      expect(@auto_grader).to receive(:grade!)
      load grader
    end

    it 'raises an error if an AutoGrader fails' do
      mock_stderr = StringIO.new
      $stderr = mock_stderr

      AutoGrader.stub(:create).and_call_original

      expect { load grader }.to raise_error
      expect(mock_stderr.string).to include('FATAL')
    end
    it 'prints out the score and comments' do
      load grader
      expect(@mock_stdout.string).to include('Score out of', '1000', 'BEGIN', 'END')
    end
  end
end
