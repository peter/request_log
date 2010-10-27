require 'spec_helper'

describe RequestLog::Middleware do
  describe "call" do
    it "invokes the logger with the data and the profiler in case of success" do
      @env = {"REQUEST_PATH" => "/v1/foobar", "HTTP_USER_AGENT" => "Mozilla/5.0"}
      @logger = mock('logger')
      @logger.expects(:call).with() { |data| data.is_a?(RequestLog::Data) && data.status == 200 && data.env == @env }
      @profiler = mock('profiler')
      @profiler.expects(:call).with() { |options| options[:result] == :success && options[:elapsed_time] > 0 }
      @rack_response = [200, {"Content-Type" => "text/html"}, "Hello, World!"]
      @app = lambda { |env| @rack_response }
      @middleware = RequestLog::Middleware.new(@app, :logger => @logger, :profiler => @profiler, :only_path => %r{\A/v\d})
      @middleware.call(@env).should == @rack_response
    end

    it "uses RequestLog::Db.requests.insert as a default logger if no logger is specified" do
      @env = env.merge("REQUEST_PATH" => "/v1/foobar", "HTTP_USER_AGENT" => "Mozilla/5.0")
      requests = mock('requests')
      requests.expects(:insert).with() { |attributes| attributes.is_a?(Hash) && attributes[:status] == 200 && attributes[:path] == '/v1/foobar' }
      ::RequestLog::Db.stubs(:requests).returns(requests)
      @rack_response = [200, {"Content-Type" => "text/html"}, "Hello, World!"]
      @app = lambda { |env| @rack_response }
      @middleware = RequestLog::Middleware.new(@app)
      @middleware.call(@env).should == @rack_response      
    end

    it "never calls logger if response content type doesn't match only_path option" do
      @env = {"REQUEST_PATH" => "/foobar", "HTTP_USER_AGENT" => "Mozilla/5.0"}
      @logger = mock('logger')
      @logger.expects(:call).never
      @profiler = mock('profiler')
      @profiler.expects(:call).never
      @rack_response = [200, {"Content-Type" => "text/html"}, "Hello, World!"]
      @app = lambda { |env| @rack_response }      
      @middleware = RequestLog::Middleware.new(@app, :logger => @logger, :profiler => @profiler, :only_path => %r{\A/v\d})
      @middleware.call(@env).should == @rack_response
    end

    it "invokes the logger with the data and the profiler if RuntimeError is raised" do
      call_middleware_with_exception(RuntimeError)
    end

    it "invokes the logger with the data and the profiler if Timeout::Error is raised" do
      call_middleware_with_exception(Timeout::Error)
    end
    
    def call_middleware_with_exception(exception_class)
      @env = {"REQUEST_PATH" => "/", "HTTP_USER_AGENT" => "Mozilla/5.0"}
      @logger = mock('logger')
      @logger.expects(:call).raises(exception_class)
      @profiler = mock('profiler')
      @profiler.expects(:call).with() { |options| options[:result] == :failure && options[:exception].is_a?(exception_class) }
      @rack_response = [200, {"Content-Type" => "text/html"}, "Hello, World!"]
      @app = lambda { |env| @rack_response }
      $stderr.expects(:puts).with() { |error_string| error_string =~ /#{exception_class.name}/ }
      @middleware = RequestLog::Middleware.new(@app, :logger => @logger, :profiler => @profiler)
      @middleware.call(@env).should == @rack_response            
    end
  end

  def env
    {"GATEWAY_INTERFACE"=>"CGI/1.1", "QUERY_STRING"=>"", "REMOTE_ADDR"=>"127.0.0.1", "REMOTE_HOST"=>"www.publish.newsdesk.local", "REQUEST_METHOD"=>"GET", "REQUEST_URI"=>"http://publish.lvh.me:3000/images/logo.png", "SCRIPT_NAME"=>"", "SERVER_NAME"=>"publish.lvh.me", "SERVER_PORT"=>"3000", "SERVER_PROTOCOL"=>"HTTP/1.1", "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/1.9.2/2010-08-18)", "HTTP_HOST"=>"publish.lvh.me:3000", "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.2) Gecko/20100316 Firefox/3.6.2", "HTTP_ACCEPT"=>"image/png,image/*;q=0.8,*/*;q=0.5", "HTTP_ACCEPT_LANGUAGE"=>"en-us,en;q=0.5", "HTTP_ACCEPT_ENCODING"=>"gzip,deflate", "HTTP_ACCEPT_CHARSET"=>"ISO-8859-1,utf-8;q=0.7,*;q=0.7", "HTTP_KEEP_ALIVE"=>"115", "HTTP_CONNECTION"=>"keep-alive", "HTTP_REFERER"=>"http://publish.lvh.me:3000/system/profiling", "HTTP_AUTHORIZATION"=>"Basic YWRtaW46aWx3d3NwYTIwMTA=", "rack.version"=>[1, 1], "rack.input"=>StringIO.new, "rack.errors"=>$stderr, "rack.multithread"=>true, "rack.multiprocess"=>false, "rack.run_once"=>false, "rack.url_scheme"=>"http", "HTTP_VERSION"=>"HTTP/1.1", "REQUEST_PATH"=>"/"}
  end  
end
