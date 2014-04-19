require_relative 'heroku_rspec_grader'
require 'net/http'


class RailsIntroArchiveGrader < HerokuRspecGrader
  def initialize(archive, grading_rules)
    super('', grading_rules)
    #TODO make it other than port 3000
    #@host_uri = 'http://localhost:3000'
    @host_uri = 'http://127.0.0.1:3000'
    @archive = archive
  end

  def run_process(cmd, dir)
    #env = {
    #    'RAILS_ROOT' => @temp,
    #    'RAILS_ENV' => 'test',
    #    'BUNDLE_GEMFILE' => 'Gemfile'
    #}
      @output, @errors, @status = Open3.capture3(
          cmd, :chdir => dir
      #env, cmd, :chdir => dir
      )
      puts (cmd +
          @output +
          @errors +
          @status.to_s) unless @status.success? and @test_errors == ''

    # Gets Net:HTTP:Persistent error
    #Open3.popen3(env, cmd) do |stdin, stdout, stderr, wait_thr|
    #  exitstatus = wait_thr.value.exitstatus
    #  out = stdout.read
    #  err = stderr.read
    #  if exitstatus != 0
    #    raise out + err
    #  end
    #end
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
      #Process.detach(pid)

      # Gets Net::HTTP::Persistent::Error on local if no timeout, increasing for travis
      # Max timeout in seconds to wait for rails to respond to http before peppering with tests
      wait_for_app_max(30)

      super

      # prev pid no good?, get now
      run_process('pgrep -f "ruby script/rails s"', '.')
      pid = @output
      Process.kill('INT', pid.to_i)
      Process.kill('KILL', pid.to_i)

    end

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

