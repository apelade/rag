require 'spec_helper'

describe FeatureGrader::Feature do

  before(:each) do

    # this fixture spec corresponds spec/fixtures/feature_grader.yml
    @fixture_spec =
        {
            "scenarios" => [
                {
                    "match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings",
                    "desc" => "restrict to movies with 'PG' or 'R' ratings"
                },
                {
                    "match" => "all (ratings|checkboxes) selected",
                    "desc" => "all ratings or checkboxes selected"
                },
                {
                    "match" => "sort movies alphabetically"
                },
                {
                    "match" => "sort movies in increasing order of release date"
                }
            ],
            "features" => [
#############################
# filter_movie_list.feature #
#############################
                {
                    "FEATURE" => "features/filter_movie_list.feature",
                    "pass" => true,
                    "weight" => 0.2,
                    "if_pass" => [
                        {
                            "FEATURE" => "features/filter_movie_list.feature",
                            "version" => 2,
                            "weight" => 0.075,
                            "desc" => "results = [G, PG-13] movies",
                            "failures" => [
                                {
                                    "match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings",
                                    "desc" => "restrict to movies with 'PG' or 'R' ratings"
                                },
                                {
                                    "match" => "all (ratings|checkboxes) selected",
                                    "desc" => "all ratings or checkboxes selected"
                                }
                            ]
                        },
                        {
                            "FEATURE" => "features/filter_movie_list.feature",
                            "version" => 3,
                            "weight" => 0.075,
                            "desc" => "results = []",
                            "failures" => [
                                {
                                    "match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings",
                                    "desc" => "restrict to movies with 'PG' or 'R' ratings"
                                },
                                {
                                    "match" => "all (ratings|checkboxes) selected",
                                    "desc" => "all ratings or checkboxes selected"
                                }
                            ]
                        },
                        {
                            "FEATURE" => "features/filter_movie_list.feature",
                            "version" => 4,
                            "weight" => 0.075,
                            "desc" => "results = [G, PG, PG-13, R] movies",
                            "failures" => [
                               {
                                   "match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings",
                                   "desc" => "restrict to movies with 'PG' or 'R' ratings"
                               }
                            ]
                        }
                    ]
                },
                {
                    "FEATURE" => "features/filter_movie_list.feature",
                    "version" => 10,
                    "weight" => 0.075,
                    "desc" => "results reversed"
                },
###########################
# sort_movie_list.feature #
###########################
                {
                    "FEATURE" => "features/sort_movie_list.feature",
                    "weight" => 0.25,
                    "if_pass" => [
                        {
                            "FEATURE" => "features/sort_movie_list.feature",
                            "version" => 10,
                            "weight" => 0.25,
                            "desc" => "results reversed",
                            "failures" => [
                                {
                                    "match" => "sort movies alphabetically"
                                },
                                {
                                    "match" => "sort movies in increasing order of release date"
                                }
                            ]
                        }
                    ]
                }
            ]
        }

    grader_double = double(FeatureGrader,
         output: [],
         m_output: double(Mutex),
         features: [],
         features_archive: "features.tar.gz",
         description: "hw3.yml",
         temp: double(TempArchiveFile ),
         tempfile: double(Tempfile,
            path: '/tmp/submission20140201-9800-mykiwl'
         ),
         logpath: '/home/adminuser/dev/rag/log/hw3_submission20140201-9800-mykiwl.log'
    )
    @fixture_features_object = double( FeatureGrader::Feature,
        grader: grader_double,
        score: {max: 0, points: 0},
        config: {},
        output: [],
        desc: nil,
        weight: 0.2,
        target_pass: true,
        failures: [],
        scenarios: {failed: [], missing: []},
        env: {"FEATURE" => "features/filter_movie_list.feature"},
        if_pass: [

            double( FeatureGrader::Feature,
                    grader: grader_double,
                    score: {max: 0, points: 0},
                    config: {},
                    output: [],
                    desc: "results = [G, PG-13] movies",
                    weight: 0.075,
                    if_pass: [],
                    target_pass: true,
                    failures: [{"match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings", "desc" => "restrict to movies with 'PG' or 'R' ratings"},
                               {"match" => "all (ratings|checkboxes) selected", "desc" => "all ratings or checkboxes selected"}],
                    scenarios: {failed: [], missing: []},
                    env: {"FEATURE" => "features/filter_movie_list.feature", "version" => "2"}
            ),

            double( FeatureGrader::Feature ,
                    grader: grader_double,
                    score: {max: 0, points: 0},
                    config: {},
                    output: [],
                    desc: "results = []",
                    weight: 0.075,
                    if_pass: [],
                    target_pass: true,
                    failures: [{"match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings", "desc" => "restrict to movies with 'PG' or 'R' ratings"},
                               {"match" => "all (ratings|checkboxes) selected", "desc" => "all ratings or checkboxes selected"}],
                    scenarios: {failed: [], missing: []},
                    env: {"FEATURE" => "features/filter_movie_list.feature", "version" => "3"}
            ),

            double( FeatureGrader::Feature,
                    grader: grader_double,
                    score: {max: 0, points: 0},
                    config: {},
                    output: [],
                    desc: "results = [G, PG, PG-13, R] movies",
                    weight: 0.075,
                    if_pass: [],
                    target_pass: true,
                    failures: [{"match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings", "desc" => "restrict to movies with 'PG' or 'R' ratings"}],
                    scenarios: {failed: [], missing: []},
                    env: {"FEATURE" => "features/filter_movie_list.feature", "version" => "4"}
            )
        ]
    )

  end

  describe FeatureGrader::Feature::TestFailedError do
    let(:testFailedError) { FeatureGrader::Feature::TestFailedError .new }
    specify { expect(testFailedError).to be_a StandardError }
  end
  describe FeatureGrader::Feature::IncorrectAnswer do
    let(:incorrectAnswer) { FeatureGrader::Feature::IncorrectAnswer .new }
    specify { expect(incorrectAnswer).to be_a StandardError }
  end
  describe FeatureGrader::Feature::SOURCE_DB do
    let(:source_db) { FeatureGrader::Feature::SOURCE_DB }
    specify { expect(source_db).to eq 'db/test.sqlite3' }
  end

  describe 'FeatureGrader::Feature::Regex' do
    it 'is a loaded module' do
      expect(FeatureGrader::Feature::Regex).to be_a(Module)
    end
    it '#BlankLine' do
      expect('' =~ FeatureGrader::Feature::Regex::BlankLine).to eq 0
      expect('test' =~ FeatureGrader::Feature::Regex::BlankLine).to be_nil
    end
    it '#FailingScenarios' do
      expect("Failing Scenarios:\n" =~ FeatureGrader::Feature::Regex::FailingScenarios).to eq 0
      expect('test' =~ FeatureGrader::Feature::Regex::FailingScenarios).to be_nil
    end
    it '#StepResult' do
      output = "88 steps (14 failed, 28 skipped, 46 passed)"
      num_steps, num_passed = output.scan(FeatureGrader::Feature::Regex::StepResult).first
      expect(num_steps).to eq '88'
      expect(num_passed).to eq '46'
      expect ('test' =~ FeatureGrader::Feature::Regex::StepResult) == nil
    end
  end

  describe 'valid nested feature object after processing' do
    let(:feature) {
      feature = @fixture_spec['features'].first
      @fgrader = FeatureGrader.new('features.tar.gz', {spec: 'hw3.yml'})
      @fgrader.send(:load_description)
      FeatureGrader::Feature.new(@fgrader, feature, {})
    }
    specify {
      puts feature.inspect
      expect(feature.grader).to be_an_instance_of(FeatureGrader)
      expect(feature.score.max).to eq 0
      expect(feature.score.points).to eq 0
      expect(feature.instance_variable_get(:@config)).to eq({})
      expect(feature.instance_variable_get(:@output)).to eq []
      expect(feature.desc).to be_nil
      expect(feature.weight).to eq 0.2
      expect(@fgrader.instance_variable_get(:@description)).to eq 'hw3.yml'
      expect(@fgrader.instance_variable_get(:@m_output)).to be_a(Mutex)

      expect(feature.target_pass).to be_true
      expect(feature.failures).to eq []
      expect(feature.scenarios).to eq({:failed=>[], :missing=>[]})
      expect(feature.instance_variable_get(:@env)).to eq({"FEATURE" => "features/filter_movie_list.feature"})

      sub_features = feature.if_pass
      expect(sub_features).to have(3).items
      expect(sub_features[0]).to be_a(FeatureGrader::Feature)
        sf0_grader = sub_features[0].grader
        expect(sf0_grader).to be_a(FeatureGrader::Feature)
          sf01_grader = sf0_grader.grader
          expect(sf01_grader).to be_a(FeatureGrader)

      expect(sub_features[1]).to be_a(FeatureGrader::Feature)
      expect(sub_features[2]).to be_a(FeatureGrader::Feature)
    }

  end


end
