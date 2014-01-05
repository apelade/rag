require_relative 'heroku_rspec_grader.rb'

class HW5Grader < HerokuRspecGrader
  def initialize(uri, grading_rules)
    super(uri, grading_rules)
    @admin_user = grading_rules[:admin_user]
    @admin_pass = grading_rules[:admin_pass]
  end

  def grade!
    ENV['ADMIN_USER'] = @admin_user
    ENV['ADMIN_PASS'] = @admin_pass
    super
  end
  
  def self.format_cli(t_opt, type, uri, user, pass, specs)
    spec_hash = {:admin_user => user, :admin_pass => pass, :spec => specs}
    ENV['ASSIGNMENT_ID'] = '5'
    super t_opt, type, uri, spec_hash
  end
end
