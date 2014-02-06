require 'spec_helper'
require './lib/graders/feature_grader/lib/feature'

FeatureClass = FeatureGrader::Feature


describe FeatureGrader::Feature do


  before(:each) do
    @feature_hash = {'FEATURE' => {}, :version => '2'}
    @feature = FeatureClass.new('grader', @feature_hash, {})
    @true_matcher  = double(FeatureGrader::ScenarioMatcher, match?: true)

  end

  describe '#total' do
    it 'totals the score' do
      pending
    end
  end

  # feature.rb line 140: incorrect result if not a StandardError
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

    # TODO assert of nil is meaningless, may not exist, put in better @feature_hash
    it 'sets instance variables' do
      expect(@feature.grader).to eq 'grader'
      expect(@feature.target_pass).to be_true
      expect(@feature.feature).to eq nil
      expect(@feature.score.to_s).to eq(Score.new.to_s)
      expect(@feature.score.points).to eq 0
      expect(@feature.score.max).to eq 0
      expect(@feature.output).to eq []
      expect(@feature.desc).to eq nil
      expect(@feature.weight).to eq 0.0
      # array of ScenarioMatchers
      expect(@feature.failures).to eq []
      expect(@feature.scenarios).to eq({failed: [], missing: []})
      # array of sub-features
      expect(@feature.if_pass).to eq []
      expect(@feature.instance_variable_get(:@config)).to eq({})
      # correct version location is in sub-features
      expect(@feature.instance_variable_get(:@env)).to eq("FEATURE" => "{}", "version" => "2")
    end

  end

  describe '#log' do
    it 'appends to output' do
      @feature.instance_variable_set(:@output, [])
      @feature.log("arg1")
      @feature.log("arg2")
      expect(@feature.output).to eq(["arg1", "arg2"])
    end
  end

  describe '#dump_output' do
    it 'dumps Feature output to grader output' do
      @feature.instance_variable_set(:@output, ["gosh"])
      expect(@feature.grader).to receive(:log).with(@feature.output)
      @feature.dump_output
    end
  end

  describe '#run!' do
    pending
  end

  describe '#correct?' do

    it 'returns true if correct! does not raise error' do
      expect(@feature.correct?).to be_true
    end
    it 'returns false if correct! raises error' do
      @feature.stub(:correct!).and_raise('an error')
      expect(@feature.correct?).to be_false
    end
  end

  describe '#correct!' do

    it 'returns true if no failures are defined' do
      @feature.instance_variable_set(:@failures, [])
      expect(@feature.correct!).to be_true
    end

    it 'returns true if failures match expected and failed scenarios exist' do
      @feature.instance_variable_set(:@failures, [@true_matcher])
      @feature.instance_variable_set(:@scenarios, { failed: ['fail def'], missing: []} )
      expect(@feature.correct!).to be_true
    end

    it 'raises error if failures match expected but no failed scenarios exist' do
      @feature.instance_variable_set(:@failures, [@true_matcher])
      @feature.instance_variable_set(:@scenarios, { failed: [], missing: []} )
      expect {@feature.correct!}.to raise_error
    end

    it 'raises error if any scenarios are missing' do
      @feature.instance_variable_set(:@failures, [@true_matcher])
      @feature.instance_variable_set(:@scenarios, { failed: ['fail def'], missing: ['missing scenario']} )
      expect {@feature.correct!}.to raise_error
    end

    # TODO feature.rb line 214 comparison is wrong? It should be unless the total == passed then raise?
    it 'raises error if failures are not defined but not all the scenario steps passed' do
      @feature.instance_variable_set(:@scenarios, {failed: ['anything'], missing: [], steps: {total:2, passed: 1}})
      expect {@feature.correct!}.not_to raise_error #.to raise_error
      @feature.instance_variable_set(:@scenarios, {failed: ['anything'], missing: [], steps: {total:1, passed: 1}})
      expect {@feature.correct!}.to raise_error # .not_to raise_error
    end


  end

  describe '#process_output' do
    it 'processes the output' do
      pending
    end
  end

end
