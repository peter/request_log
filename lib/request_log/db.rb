module RequestLog
  class Db
    @@mongo_db = nil

    def self.mongo_db=(mongo_db)
      @@mongo_db = mongo_db
    end
    
    def self.mongo_db
      @@mongo_db ||= default_mongo_db
    end
    
    def self.requests
      mongo_db['requests']
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
    
    private
    
    def self.default_mongo_db
      return nil unless ENV['MONGOHQ_URL']
      require 'uri'
      require 'mongo'      
      uri = URI.parse(ENV['MONGOHQ_URL'])
      connection = Mongo::Connection.from_uri(uri.to_s)
      connection.db(uri.path.gsub(/^\//, ''))
    end
  end
end
