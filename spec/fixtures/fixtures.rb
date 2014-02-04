# this file is probably not needed
module Fixtures
  def self.feature_grader_yml_hash
    { "scenarios" => [
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
                  { "FEATURE" => "features/filter_movie_list.feature",
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
  end
end
