require_relative 'weighted_rspec_grader'
class CapybaraRspecGrader < WeightedRspecGrader
  def initialize(path, grading_rules)
    @path = File.absolute_path(path)
    grading_rules = {:spec => File.absolute_path(grading_rules[:spec])}
    super('', grading_rules)
  end

  def grade!

    ENV['APP_PATH'] = @path
    #ENV['RAILS_ROOT'] = @path
    #ENV['RAILS_ENV']= 'test'


    runner =  RspecRunner.new('', File.absolute_path(@specfile) )
    Dir.chdir(@path){
      runner.run
    }

    @raw_score = 0
    @raw_max = 0
    @comments = runner.output

    runner.output.each_line do |line|
      if line =~ /\[(\d+) points?\]/
        points = $1.to_i
        @raw_max += points
        @raw_score += points unless line =~ /\(FAILED([^)])*\)/
      elsif line =~ /^Failures:/
        mode = :log_failures
        break
      end
    end
    #Process.fork do
    #  Process.exec super
    #end
    #Dir.chdir(ENV['RAILS_ROOT']){
    #  super
    #}
    #Dir.chdir(@path)

    #super

  #  @o,@e,@s = Open3.capture3({},'rspec', :chdir=>@path)
  #  puts @o,@e,@s
  end
end
