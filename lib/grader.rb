require './lib/auto_grader.rb'

class Grader

  def self.cli(args)
    return self.help if args.length < 4
    type = args[1] # TODO parse opts here, Kernel.const_get(type).format_cli
    # Emulate rag/grade3
    if type == 'HW3Grader'
      working_dir = args[3]
      # Set and restore ENV['BUNDLE_GEMFILE'] when run with 'bundle exec'.
      # rag/grade3 set ENV['RAILS_ROOT']. It seems to do nothing. Related?
      working_gemfile  = working_dir+'/Gemfile'
      original_gemfile = Dir.getwd+'/Gemfile'
      Dir.chdir(working_dir){
        ENV['BUNDLE_GEMFILE'] = working_gemfile
        autograder_args = HW3Grader.format_cli *args
        g = AutoGrader.create *autograder_args
        g.grade!
        ENV['BUNDLE_GEMFILE'] = original_gemfile
        return self.feedback g
      }
    else
      args[2] = IO.read(args[2]) if type == 'WeightedRspecGrader'
      g = AutoGrader.create('1', args[1] ,args[2] ,:spec => args[3])
      g.grade!
      return self.feedback g
    end
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