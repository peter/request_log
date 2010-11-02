module RequestLog
  class Data
    attr_accessor :env, :status, :headers, :response, :app_time

    def initialize(env, rack_response, app_time)
      self.env = env
      self.status = rack_response[0]
      self.headers = rack_response[1]
      self.response = rack_response[2]
      self.app_time = app_time
    end

    def self.request_path(env)
      env['PATH_INFO'] || env['REQUEST_PATH'] || "/"
    end
    
    def attributes
      method       = env['REQUEST_METHOD']
      path         = self.class.request_path(env)
      {
        :method            => method,
        :path              => path, 
        :status            => status, 
        :time              => Time.now.utc,
        :runtime           => app_time,
        :ip                => env['REMOTE_ADDR'],
        :params            => params
      }
    end
    
    def params
      # NOTE: It seems getting POST params with ::Rack::Request.new(env).params does not work well with Rails
      (env['action_controller.instance'] || ::Rack::Request.new(env)).params      
    end
  end
end
