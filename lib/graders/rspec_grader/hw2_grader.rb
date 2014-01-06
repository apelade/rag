require_relative 'heroku_rspec_grader.rb'

class HW2Grader < HerokuRspecGrader

  ASSIGNMENT_ID = '2'
  
  def self.format_cli(t_option, type, uri, specs)
    spec_hash = {:spec => specs}
    return ASSIGNMENT_ID, type, uri, spec_hash
  end
end
