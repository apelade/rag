require './lib/auto_grader.rb'

class Grader

  def self.cli(args)
    return help unless args.length >= 4
    return run_grader args unless args.index '-a'
    return run_elsewhere args
  end
  
  def self.run_grader(args)
    return help unless args.index '-t'
    type = args[1]
    formatted_args = Kernel.const_get(type).format_cli *args
    g = AutoGrader.create *formatted_args
    g.grade!
    self.feedback(g)
  end
  
  def self.run_elsewhere(args)
    a_index = args.index '-a'
    return help unless a_index && args.length > a_index.to_i + 1
    tmp_dir = args[a_index + 1]
    Dir.chdir(tmp_dir){
      run_grader args
    }#rescue ENOENT, "Dir #{tmp_dir} may not exist or be writable"
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
