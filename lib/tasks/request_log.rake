require 'set'

namespace :request_log do
  desc "Tail the request log"
  task :tail do
    wait_time = 10
    printed_ids = Set.new
    while(true)
      time_condition = {"time" => {"$gt" => (Time.now - wait_time).utc}}
      filter_conditions = RequestLog::Db.parse_conditions(ENV['conditions'])
      RequestLog::Db.requests.find(filter_conditions.merge(time_condition)).each do |r|
        unless printed_ids.include?(r['_id'])
          puts
          puts RequestLog::Db.printable_request(r)
          printed_ids << r['_id']
        end
      end
      sleep (wait_time-1)
    end
  end
  
  desc %q{Print a part of the log. Parameters: from='YYYY-MM-DD HH:MM' to='YYYY-MM-DD HH:MM' conditions=<ruby-hash-with-mongo-db-conditions>}
  task :print do
    from = ENV['from'] || (Time.now-600).utc
    to = ENV['to'] || Time.now.utc
    RequestLog::Db.print_requests(from, to, ENV['conditions'])
  end
end
