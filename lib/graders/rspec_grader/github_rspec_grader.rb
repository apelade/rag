require_relative 'weighted_rspec_grader'

class GithubRspecGrader < WeightedRspecGrader
  def initialize(username, grading_rules)
    super('', grading_rules)
    ENV['GITHUB_USERNAME'] = username.strip.delete("\n")
  end

  ASSIGNMENT_ID = 'Github ID'
  
  def self.format_cli(t_option, type, file, specs)
    # Refuse super file read
    RspecGrader.format_cli ASSIGNMENT_ID, type, file, specs
  end
end
