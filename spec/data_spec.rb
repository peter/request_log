require 'spec_helper'

describe RequestLog::Data do
  describe "attributes" do
    before(:each) do
      @env = env
      @rack_response = [200, {"Content-Type" => "text/html"}, "Hello, World!"]
      @app_time = 0.22666      
      @data = RequestLog::Data.new(@env, @rack_response, @app_time)
    end
    
    it "returns a hash with information about a request" do
      puts "running spec"
      attributes = @data.attributes
      attributes[:summary].should be_nil
      attributes[:runtime].should == @app_time
      attributes[:time].should >= (Time.now-1).utc
      attributes[:time].should <= Time.now.utc
      attributes[:method].should == "GET"
      attributes[:path].should == "/images/logo.png"
      attributes[:ip].should == "127.0.0.1"
    end
  end
  
  def env
    {"GATEWAY_INTERFACE"=>"CGI/1.1", "PATH_INFO"=>"/images/logo.png", "QUERY_STRING"=>"", "REMOTE_ADDR"=>"127.0.0.1", "REMOTE_HOST"=>"www.publish.newsdesk.local", "REQUEST_METHOD"=>"GET", "REQUEST_URI"=>"http://publish.lvh.me:3000/images/logo.png", "SCRIPT_NAME"=>"", "SERVER_NAME"=>"publish.lvh.me", "SERVER_PORT"=>"3000", "SERVER_PROTOCOL"=>"HTTP/1.1", "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/1.9.2/2010-08-18)", "HTTP_HOST"=>"publish.lvh.me:3000", "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.2) Gecko/20100316 Firefox/3.6.2", "HTTP_ACCEPT"=>"image/png,image/*;q=0.8,*/*;q=0.5", "HTTP_ACCEPT_LANGUAGE"=>"en-us,en;q=0.5", "HTTP_ACCEPT_ENCODING"=>"gzip,deflate", "HTTP_ACCEPT_CHARSET"=>"ISO-8859-1,utf-8;q=0.7,*;q=0.7", "HTTP_KEEP_ALIVE"=>"115", "HTTP_CONNECTION"=>"keep-alive", "HTTP_REFERER"=>"http://publish.lvh.me:3000/system/profiling", "HTTP_AUTHORIZATION"=>"Basic YWRtaW46aWx3d3NwYTIwMTA=", "rack.version"=>[1, 1], "rack.input"=>StringIO.new, "rack.errors"=>$stderr, "rack.multithread"=>true, "rack.multiprocess"=>false, "rack.run_once"=>false, "rack.url_scheme"=>"http", "HTTP_VERSION"=>"HTTP/1.1", "REQUEST_PATH"=>"/"}
  end
end
