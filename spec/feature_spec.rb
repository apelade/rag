#it 'build a funky hash stored in @features to be processed by the grader' do
#  #    hash structure:
#  #     config: {temp: TempArchiveFile}
#  #     desc: ?
#  #     env: {'FEATURE' => }
#end

# this fixture spec corresponds spec/fixtures/feature_grader.yml
#@fixture_spec ={ "scenarios" => [
#    {
#        "match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings",
#        "desc" => "restrict to movies with 'PG' or 'R' ratings"
#    },
#    {
#        "match" => "all (ratings|checkboxes) selected",
#        "desc" => "all ratings or checkboxes selected"
#    },
#    {
#        "match" => "sort movies alphabetically"
#    },
#    {
#        "match" => "sort movies in increasing order of release date"
#    }
#],
#                 "features" => [
#                     {
#                         "FEATURE" => "features/filter_movie_list.feature",
#                         "pass" => true,
#                         "weight" => 0.2,
#                         "if_pass" => [
#                             {
#                                 "FEATURE" => "features/filter_movie_list.feature",
#                                 "version" => 2,
#                                 "weight" => 0.075,
#                                 "desc" => "results = [G, PG-13] movies",
#                                 "failures" => [
#                                     {
#                                         "match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings",
#                                         "desc" => "restrict to movies with 'PG' or 'R' ratings"
#                                     },
#                                     {
#                                         "match" => "all (ratings|checkboxes) selected",
#                                         "desc" => "all ratings or checkboxes selected"
#                                     }
#                                 ]
#                             },
#                             {
#                                 "FEATURE" => "features/filter_movie_list.feature",
#                                 "version" => 3,
#                                 "weight" => 0.075,
#                                 "desc" => "results = []",
#                                 "failures" => [
#                                     {
#                                         "match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings",
#                                         "desc" => "restrict to movies with 'PG' or 'R' ratings"
#                                     },
#                                     {
#                                         "match" => "all (ratings|checkboxes) selected",
#                                         "desc" => "all ratings or checkboxes selected"
#                                     }
#                                 ]
#                             },
#                             { "FEATURE" => "features/filter_movie_list.feature",
#                               "version" => 4,
#                               "weight" => 0.075,
#                               "desc" => "results = [G, PG, PG-13, R] movies",
#                               "failures" => [
#                                   {
#                                       "match" => "restrict to movies with [\"']PG[\"'] or [\"']R[\"'] ratings",
#                                       "desc" => "restrict to movies with 'PG' or 'R' ratings"
#                                   }
#                               ]
#                             }
#                         ]
#                     },
#                     {
#                         "FEATURE" => "features/filter_movie_list.feature",
#                         "version" => 10,
#                         "weight" => 0.075,
#                         "desc" => "results reversed"
#                     },
#                     {
#                         "FEATURE" => "features/sort_movie_list.feature",
#                         "weight" => 0.25,
#                         "if_pass" => [
#                             {
#                                 "FEATURE" => "features/sort_movie_list.feature",
#                                 "version" => 10,
#                                 "weight" => 0.25,
#                                 "desc" => "results reversed",
#                                 "failures" => [
#                                     {
#                                         "match" => "sort movies alphabetically"
#                                     },
#                                     {
#                                         "match" => "sort movies in increasing order of release date"
#                                     }
#                                 ]
#                             }
#                         ]
#                     }
#                 ]
#}

#@valid_specs = {
#    "scenarios" => [{ "match" => "a regex", "desc" => "print-friendly literal of regex" }],
#
#    "features" => [
#        { "FEATURE" =>
#              "features/feature_1",
#          "pass" => true,
#          "weight" => 0.2,
#          "if_pass" => [
#              { "FEATURE" =>
#                    "features/feature_1-1",
#                "version" => 2,
#                "weight" => 0.075,
#                "desc" => "results = [G, PG-13] movies",
#                "failures" => [{ "match" => "the same regex", "desc" => "print-friendly literal of regex" }] },
#              { "FEATURE" =>
#                    "features/feature_1-2",
#                "version" => 2,
#                "weight" => 0.075,
#                "desc" => "results = [G, PG-13] movies",
#                "failures" => [{ "match" => "the same regex", "desc" => "print-friendly literal of regex" }] }
#          ]
#        }
#    ]
#}
#
#it 'processes the document into an array of Feature objects with instance vars for Grader and sub-Features contained by if_pass' do
#  @feature_grader.send(:load_description)
#
#  features_array = @feature_grader.instance_variable_get(:@features)
#  #expect(features_array).to eq []
#
#  root_feature = features_array[0]
#  expect(root_feature).to be_a FeatureGrader::Feature
#
#  grader = root_feature.instance_variable_get(:@grader)
#  expect(grader).to be_a FeatureGrader
#
#  # if a general case passes, run more specific tests
#  child_features = root_feature.instance_variable_get(:@if_pass)
#  expect(child_features[0]).to be_a FeatureGrader::Feature
#
#  # version is used as a feature flag in the solution code to change behavior
#  expect(child_features[0].instance_variable_get(:@env)['version']).to eq '2'
#end
