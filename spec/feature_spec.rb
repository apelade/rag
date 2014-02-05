require 'spec_helper'
require './lib/graders/feature_grader/lib/feature'

FeatureClass = FeatureGrader::Feature


describe FeatureGrader::Feature do

  before(:each) do

    @grader_double = double(FeatureGrader,
         output: [],
         m_output: double(Mutex),
         features: [],
         features_archive: "features.tar.gz",
         description: 'spec/fixtures/feature_grader.yml',
         temp: double(TempArchiveFile ),
         tempfile: double(Tempfile,
            path: '/tmp/submission20140201-9800-mykiwl'
         ),
         logpath: '/home/adminuser/dev/rag/log/hw3_submission20140201-9800-mykiwl.log'
    )

  end

  describe 'FeatureClass::TestFailedError' do
    let(:testFailedError) { FeatureClass::TestFailedError .new }
    specify { expect(testFailedError).to be_a StandardError }
  end
  describe 'FeatureClass::IncorrectAnswer' do
    let(:incorrectAnswer) { FeatureClass::IncorrectAnswer .new }
    specify { expect(incorrectAnswer).to be_a StandardError }
  end
  describe 'FeatureClass::SOURCE_DB' do
    let(:source_db) { FeatureClass::SOURCE_DB }
    specify { expect(source_db).to eq 'db/test.sqlite3' }
  end

  describe 'FeatureClass::Regex' do
    it 'is a loaded module' do
      expect(FeatureClass::Regex).to be_a(Module)
    end
    it '#BlankLine' do
      expect('' =~ FeatureClass::Regex::BlankLine).to eq 0
      expect('test' =~ FeatureClass::Regex::BlankLine).to be_nil
    end
    it '#FailingScenarios' do
      expect("Failing Scenarios:\n" =~ FeatureClass::Regex::FailingScenarios).to eq 0
      expect('test' =~ FeatureClass::Regex::FailingScenarios).to be_nil
    end
    it '#StepResult' do
      output = "88 steps (14 failed, 28 skipped, 46 passed)"
      num_steps, num_passed = output.scan(FeatureClass::Regex::StepResult).first
      expect(num_steps).to eq '88'
      expect(num_passed).to eq '46'
      expect ('test' =~ FeatureClass::Regex::StepResult) == nil
    end
  end

  describe '#new' do
    it 'raises error if there is no FEATURE specified' do
      expect {FeatureClass.new('',{'No Feature' => ''},{})}.to raise_error
    end

    it 'sets instance variables' do
      feature_hash = {'FEATURE' => {}}
      feature = FeatureClass.new('grader', feature_hash, {})
      expect(feature.grader).to eq 'grader'
      expect(feature.target_pass).to be_true
      expect(feature.feature).to eq nil
      expect(feature.score.to_s).to eq(Score.new.to_s)
      expect(feature.score.points).to eq 0
      expect(feature.score.max).to eq 0
      expect(feature.output).to eq []
      expect(feature.desc).to eq nil
      expect(feature.weight).to eq 0.0
      expect(feature.failures).to eq []
      expect(feature.scenarios).to eq({failed: [], missing: []})
      expect(feature.instance_variable_get(:@env)).to eq("FEATURE" => "{}")
      expect(feature.instance_variable_get(:@config)).to eq({})
      expect(feature.if_pass).to eq []
      expect(feature.target_pass).to be_true
      expect(feature.failures).to eq []
    end


  end

end
