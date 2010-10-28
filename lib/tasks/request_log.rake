require 'set'

namespace :request_log do
  desc "Tail the request log"
  task :tail do
    wait_time = 10
    printed_ids = Set.new
    while(true)
      RequestLog::Db.requests.find("time" => {"$gt" => (Time.now - wait_time).utc}).each do |r|
        unless printed_ids.include?(r['_id'])
          puts RequestLog::Db.printable_request(r)
          puts
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
    if conditions = ENV['conditions']
      # We need to parse a Ruby hash here, let's not require braces
      conditions = "{#{conditions}}" unless conditions[0] == "{"
      conditions = eval(conditions)
    else
      conditions = {}
    end
    RequestLog::Db.print_requests(from, to, conditions)
  end
end
