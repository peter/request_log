module RequestLog
  class Db
    @@mongo_db = nil

    def self.mongo_db=(mongo_db)
      @@mongo_db = mongo_db
    end
    
    def self.mongo_db
      @@mongo_db
    end
    
    def self.requests
      mongo_db['requests']
    end
    
    def self.profiling
      mongo_db['request_log_profiling']
    end
    
    def self.printable_request(request)
      request.keys.reject { |key| key == "_id" }.map do |key|
        "#{key}: #{request[key].inspect}"
      end.join("\n")
    end

    def self.filtered_requests(start_time, end_time, conditions = {})
      start_time = Time.parse(start_time).utc if start_time.is_a?(String)
      end_time = Time.parse(end_time).utc if end_time.is_a?(String)
      time_condition = {"time" => {"$gt" => start_time, "$lt" => end_time}}
      requests.find(time_condition.merge(conditions))
    end
    
    def self.print_requests(start_time, end_time, conditions = {})
      filtered_requests(start_time, end_time, conditions).each do |request|
        puts printable_request(request)
        puts
      end
    end
  end
end
