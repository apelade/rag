require_relative 'weighted_rspec_grader'

class GithubRspecGrader < WeightedRspecGrader
  def initialize(username, grading_rules)
    super('', grading_rules)
    ENV['GITHUB_USERNAME'] = username.strip.delete("\n")
  end

  def self.format_cli(t_opt, type, file, specs)
    ENV['ASSIGNMENT_ID'] = 'Github ID'
    # Refuse super file read
    RspecGrader.format_cli t_opt, type, file, specs
  end
end
