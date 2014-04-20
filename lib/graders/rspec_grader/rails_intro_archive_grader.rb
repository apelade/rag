require_relative 'heroku_rspec_grader'
require 'net/http'


class RailsIntroArchiveGrader < HerokuRspecGrader

  def initialize(archive, grading_rules)
    super('', grading_rules)
    #TODO make it other than port 3000
    #Leave as ip addr, not 'http://localhost:3000'
    @host_uri = 'http://127.0.0.1:3000'
    @archive = archive
  end


  def grade!
    #TODO confirm needed in super
    ENV['HEROKU_URI'] = @host_uri

    Dir.mktmpdir('rails_intro_archive', '/tmp') do |tmpdir|

      @temp = tmpdir
      run_process("tar -xvf #{@archive} -C /#{@temp}", '.')
      pid = Process.fork do
        run_process('rails s', @temp)
      end
      rails_up_timeout(30)

      super.tap

      # prev pid no good?, get now
      run_process('pgrep -f "ruby script/rails s"', '.')
      pid = @output.to_i if @output.to_i > 0
      Process.kill('INT', pid.to_i)
      Process.kill('KILL', pid.to_i)
    end
    
  end


  def run_process(cmd, dir)
    @output, @errors, @status = Open3.capture3(
        cmd, :chdir => dir
    )
    puts (cmd +
        @output +
        @errors +
        @status.to_s) unless @status.success? and @errors == ''
  end


  def rails_up_timeout(sec, interval=1)
    to_status = timeout(sec) {
      sleep(interval) until app_loaded?
    }
  end


  #TODO use mechanize
  def app_loaded?
    begin
      uri = URI.parse(@host_uri)
      response = Net::HTTP.get_response(uri)
      return true if response and response.code # && response.code == '200'
    rescue Errno::ECONNREFUSED
      return false
    end
    false
  end


end

