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
      request.keys.map do |key|
        "#{key}: #{request[key].inspect}"
      end.join("\n")
    end

    def self.filtered_requests(start_time, end_time, condition = {})
      time_condition = {"time" => {"$gt" => Time.parse(start_time).utc, "$lt" => Time.parse(end_time).utc}}
      requests.find(time_condition.merge(condition))
    end
    
    def self.print_requests(start_time, end_time, condition = {})
      filtered_requests(start_time, end_time, condition).each do |request|
        puts printable_request(request)
        puts
      end
    end
  end
end
