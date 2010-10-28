module RequestLog
  class Profiler
    def self.default_values
      {
        :success_count => 0,
        :failure_count => 0,
        :failure_exceptions => {},
        :min_time => nil,
        :max_time => nil,
        :avg_time => nil,
        :persist_enabled => false,
        :persist_frequency => 2000
      }
    end

    def self.attribute_names
      default_values.keys
    end

    attribute_names.each do |attribute|
      # cattr_accessor from ActiveSupport library
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        @@#{attribute} = nil

        def self.#{attribute}=(obj)
          @@#{attribute} = obj
        end
        
        def self.#{attribute}
          @@#{attribute}
        end
      EOS
    end

    def self.reset
      attribute_names.each do |attribute|
        send("#{attribute}=", default_values[attribute])
      end
      self
    end

    reset

    def self.call(options = {})
      if options[:result] == :success
        self.success_count += 1
        update_times(options[:elapsed_time])
      else
        self.failure_count += 1
        if options[:exception]
          failure_exceptions[options[:exception].class.name] ||= 0
          failure_exceptions[options[:exception].class.name] += 1
        end
      end
      persist! if should_persist?
    end

    def self.total_count
      success_count + failure_count
    end

    def self.failure_ratio
      failure_count.to_f/total_count
    end

    def self.attributes
      attribute_names.inject({}) do |hash, attribute|
        hash[attribute] = send(attribute)
        hash
      end
    end

    def self.persist!
      ::RequestLog::Db.profiling.insert(
        :total_count => total_count,
        :failure_ratio => failure_ratio,
        :max_time => max_time,
        :avg_time => avg_time,
        :data => attributes
      )
    end

    def self.should_persist?
      persist_enabled && (total_count % persist_frequency == 0)
    end

    def self.to_s
      attributes.inspect
    end

    private

    def self.update_times(elapsed_time)
      initialize_times(elapsed_time)
      self.min_time = elapsed_time if elapsed_time < min_time
      self.max_time = elapsed_time if elapsed_time > max_time
      self.avg_time = (avg_time*(success_count - 1) + elapsed_time)/success_count
    end

    def self.initialize_times(elapsed_time)
      self.min_time ||= elapsed_time
      self.max_time ||= elapsed_time
      self.avg_time ||= elapsed_time    
    end
  end
end
