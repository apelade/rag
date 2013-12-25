require './lib/auto_grader.rb'

class Grader
  def self.cli(args)
    begin
      case type = args[1]
        when 'HW3Grader' then return Kernel.const_get(type).cli args
        when /RspecGrader/ then return handle_rspec_grader args
        else return help
      end
    rescue
      return help
    end
  end
  def self.handle_rspec_grader(args)
    t_opt, type, file, specs = args
    file = IO.read file if type == 'WeightedRspecGrader'
    g = AutoGrader.create '1', type, file, :spec => specs
    g.grade!
    feedback g
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

