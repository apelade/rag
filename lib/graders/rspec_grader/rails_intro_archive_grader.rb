require_relative 'heroku_rspec_grader'
require 'net/http'


class RailsIntroArchiveGrader < HerokuRspecGrader


  def initialize(archive, grading_rules)
    super('', grading_rules)
    #TODO make it other than port 3000
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

      wait_for_app_max(30)

      super

      # prev pid no good?, get now
      run_process('pgrep -f "ruby script/rails s"', '.')
      pid = @output
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
        @status.to_s) unless @status.success? and @test_errors == ''
  end


  def wait_for_app_max(sec, polling=1)
    to_status = timeout(sec) {
      sleep(polling) until app_loaded?
    }
  end


  def app_loaded?
    begin
      #return true if `pgrep -f "ruby script/rails s"` != ''
      # Cannot use localhost, use 127.0.0.1
      uri = URI.parse(@host_uri+'/movies/')
      response = Net::HTTP.get_response(uri)
      if response and response.code
        return true if response.respond_to?(:code) #&& response.code == '200'
      end
    rescue Errno::ECONNREFUSED
      return false
    end
    false
  end


end

