module RequestLog
  class Middleware
    def initialize(app, options = {})
      @app = app
      @logger = options[:logger] || lambda { |data| ::RequestLog::Db.requests.insert(data.attributes) }
      @profiler = options[:profiler] || ::RequestLog::Profiler
      @timeout = options[:timeout] || 0.3
      @only_path = options[:only_path]
    end

    def call(env)
      app_start = Time.now 
      rack_response = @app.call(env)
      app_time = Time.now - app_start
      return rack_response unless should_log?(env)
      begin
        logger_start = Time.now
        Timeout::timeout(@timeout) do
          @logger.call(::RequestLog::Data.new(env, rack_response, app_time))
        end
        @profiler.call(:result => :success, :elapsed_time => (Time.now - logger_start))
      rescue Exception => e
        @profiler.call(:result => :failure, :exception => e)
        $stderr.puts("#{self.class}: exception #{e} #{e.backtrace.join("\n")}")
      ensure
        return rack_response  
      end
    end
    
    private
    
    def should_log?(env)
      if @only_path && ::RequestLog::Data.request_path(env) !~ @only_path
        false
      else
        true
      end
    end
  end
end
