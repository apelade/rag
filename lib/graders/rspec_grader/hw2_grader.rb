require_relative 'heroku_rspec_grader.rb'

class HW2Grader < HerokuRspecGrader

  def self.format_cli(t_opt, type, uri, specs)
    spec_hash = {:spec => specs}
    ENV['ASSIGNMENT_ID'] = '2'
    super t_opt, type, uri, spec_hash
  end
end
