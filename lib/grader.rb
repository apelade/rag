require './lib/auto_grader.rb'

class Grader
  def self.cli(args)
    begin
      case type = args[1]
        when 'HW3Grader' then return Kernel.const_get(type).cli args
        when /Grader/ then return handle_rspec_grader args
        else return self.help
      end
    rescue
      return self.help
    end
  end
  def self.handle_rspec_grader(args)
    t_opt, type, file, specs = args
    file = IO.read file if type == 'WeightedRspecGrader'
    spec_hash = {:spec => specs}
    if type == 'HW5Grader'
      t_opt, type, file, user, pass, specs = args
      spec_hash = {:admin_user => user, :admin_pass => pass, :spec => specs}
    end
    g = AutoGrader.create '1', type, file, spec_hash
    g.grade!
    self.feedback g
  end
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

