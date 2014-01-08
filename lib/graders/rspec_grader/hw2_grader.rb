require_relative 'heroku_rspec_grader.rb'

class HW2Grader < HerokuRspecGrader

  @assignment_id= '2'
  
  def self.format_cli(t_option, type, uri, specs)
    spec_hash = {:spec => specs}
    return @assignment_id, type, uri, spec_hash
  end
end
