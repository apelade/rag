#!/usr/bin/env ruby
require './lib/auto_grader'
require 'optparse'

#TODO YA consider removing as gets required in AutoGrader
require './lib/graders/feature_grader/hw3_grader.rb'

options = {:mt => true}
o = nil
OptionParser.new do |opts|
  o = opts
  opts.banner = "Usage: #{$0} [options] -a /path/to/app/ input.tar.gz description.yml"
  opts.on('-a', '--app PATH', 'Path to app') {|p| options[:app] = p}
  opts.on('-h', '--help', 'Display this screen') { puts opts; exit }
  opts.on('-m', '--[no-]multithread', 'Enable multithreading') {|v| options[:mt] = v}
end.parse!

unless options[:app] and ARGV.count == 2
  puts o
  exit 0
end

d = Dir::getwd

begin
  ARGV.collect! {|p| File.expand_path p}
#TODO YA this should be done in the cuke_runner, if done at all
  Dir::chdir options.delete(:app)
#TODO YA this does not seem to affect anything
  ENV["RAILS_ROOT"] = Dir::getwd
  options[:description] = ARGV[1]

  begin
    g = AutoGrader.create('3', 'HW3Grader', ARGV[0], options)
    g.grade!
  rescue Object => e
    $stderr.puts "*** FATAL: #{e.respond_to?(:message) ? e.message : "unspecified error"}"
    exit 0
  end
  score_max = 500
  puts "Score out of #{score_max}: #{g.normalized_score(score_max)}\n"
  puts "---BEGIN cucumber comments---\n#{'-'*80}\n#{g.comments}\n#{'-'*80}\n---END cucumber comments---"
ensure
  Dir::chdir d
end
