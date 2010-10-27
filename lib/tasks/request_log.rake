require 'set'

namespace :log do
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
end
