require './lib/auto_grader.rb'

class Grader
  def self.cli(args)
    begin
      case type = args[1]
        when 'HW3Grader' then return Kernel.const_get(type).cli args
        when /Grader/ then return handle_rspec_grader args
        else return help
      end
    rescue
      return help
    end
  end
  def self.handle_rspec_grader(args)
    t_opt, type, file, specs = args
    file = IO.read file if type == 'WeightedRspecGrader'
    spec_hash = {:spec => specs}
    spec_hash = {:admin_user => args[3], :admin_pass => args[4], :spec => args[5]} if type == 'HW5Grader'
    g = AutoGrader.create '1', type, file, spec_hash
    g.grade!
    feedback g
  end
=begin
  def self.handle_heroku_grader(args)
    t_opt, type, file, specs = args
    debugger
    g = AutoGrader.create '5', type, file, :spec => specs
    g.grade!
    feedback g
  end
=end
  def self.feedback(g)
    <<EndOfFeedback
Score out of 100: #{g.normalized_score(100)}
---BEGIN rspec comments---
#{'-'*80}
#{g.comments}
#{'-'*80}
---END rspec comments---
EndOfFeedback
  end
  def self.help
    <<EndOfHelp
Usage: #{$0} -t GraderType submission specfile.rb

Creates an autograder of the specified subclass and grades the submission file with it.

For example, try these, where PREFIX=rag/spec/fixtures:

#{$0} -t WeightedRspecGrader $PREFIX/correct_example.rb $PREFIX/correct_example.spec.rb
#{$0} -t WeightedRspecGrader $PREFIX/example_with_syntax_error.rb $PREFIX/correct_example.spec.rb
#{$0} -t WeightedRspecGrader $PREFIX/example_with_runtime_exception.rb $PREFIX/correct_example.spec.rb

EndOfHelp
  end
end

