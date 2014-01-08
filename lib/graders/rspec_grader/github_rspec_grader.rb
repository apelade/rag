require_relative 'weighted_rspec_grader'

class GithubRspecGrader < WeightedRspecGrader

  def initialize(username, grading_rules)
    super('', grading_rules)
    ENV['GITHUB_USERNAME'] = username.strip.delete("\n")
  end

  @assignment_id = 'Github ID'

  def self.format_cli(t_option, type, file, specs)
    # Refuse super file read
    RspecGrader.format_cli @assignment_id, type, file, specs
  end
end
