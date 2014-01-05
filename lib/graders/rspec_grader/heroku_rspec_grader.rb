require_relative 'weighted_rspec_grader'

class HerokuRspecGrader < WeightedRspecGrader
  def initialize(uri, grading_rules)
    super('', grading_rules)
    @heroku_uri = uri
  end

  def grade!
    ENV['HEROKU_URI'] = @heroku_uri
    super
  end

  def self.format_cli(t_opt, type, file, user, pass, specs)
    spec_hash = {:admin_user => user, :admin_pass => pass, :spec => specs}
    return [ENV['ASSIGNMENT_ID'], type, file, spec_hash]
  end
end
