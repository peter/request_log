require 'spec_helper'

describe RequestLog::Profiler do
  before(:each) do
    profiler.reset
  end
  
  describe "call" do
    describe "result => success" do
      it "increments success_count and time stats" do
        profiler.success_count.should == 0
        profiler.call(:result => :success, :elapsed_time => 0.5)
        profiler.success_count.should == 1
        profiler.total_count.should == 1
        profiler.min_time.should == 0.5
        profiler.max_time.should == 0.5
        profiler.avg_time.should == 0.5
        profiler.call(:result => :success, :elapsed_time => 0.6)
        profiler.success_count.should == 2
        profiler.total_count.should == 2
        profiler.min_time.should == 0.5
        profiler.max_time.should == 0.6
        profiler.avg_time.should == 0.55
        profiler.call(:result => :success, :elapsed_time => 0.7)
        profiler.success_count.should == 3
        profiler.min_time.should == 0.5
        profiler.max_time.should == 0.7
        profiler.avg_time.should == 0.6
      end
    end

    describe "result => failure" do
      it "increments failure_count" do
        profiler.failure_count.should == 0
        profiler.call(:result => :failure)
        profiler.failure_count.should == 1
        profiler.total_count.should == 1
        profiler.call(:result => :failure)
        profiler.failure_count.should == 2
        profiler.total_count.should == 2
      end
      
      it "sets failure_exceptions if an exception is passed" do
        profiler.failure_count.should == 0
        profiler.failure_exceptions.should == {}
        profiler.call(:result => :failure, :exception => RuntimeError.new("some exception"))
        profiler.failure_count.should == 1
        profiler.failure_exceptions.should == {"RuntimeError" => 1}
        profiler.call(:result => :failure, :exception => Timeout::Error.new("some timeout"))
        profiler.failure_count.should == 2        
        profiler.failure_exceptions.should == {"RuntimeError" => 1, "Timeout::Error" => 1}
        profiler.call(:result => :failure, :exception => Timeout::Error.new("some timeout"))
        profiler.failure_count.should == 3        
        profiler.failure_exceptions.should == {"RuntimeError" => 1, "Timeout::Error" => 2}
      end
    end    

    describe "persist!" do
      it "does not get invoked if should_persist? == false" do
        profiler.stubs(:should_persist?).returns(false)
        profiler.expects(:persist!).never
        profiler.call(:result => :success, :elapsed_time => 0.6)
      end

      it "does get invoked if should_persist? == true" do
        profiler.stubs(:should_persist?).returns(true)        
        profiler.expects(:persist!).once
        profiler.call(:result => :success, :elapsed_time => 0.6)
      end
    end
  end
  
  describe "total_count" do
    it "is failure_count + success_count" do
      profiler.failure_count = 427
      profiler.success_count = 10000
      profiler.total_count.should == 10427
    end
  end
  
  describe "failure_ratio" do
    it "is failure_count/total_count" do
      profiler.failure_count = 1
      profiler.success_count = 0
      profiler.failure_ratio.should == 1.0
      
      profiler.failure_count = 1
      profiler.success_count = 1
      profiler.failure_ratio.should == 0.5
      
      profiler.failure_count = 1
      profiler.success_count = 9
      profiler.failure_ratio.should == 0.1
    end
  end

  describe "persist!" do
    it "stores profiling info in mongo db" do
      profiler.success_count = 80
      profiler.failure_count = 20
      profiler.avg_time = 0.0003
      profiler.max_time = 0.09
      profiling = mock('profiling')
      profiling.expects(:insert).with(
        :total_count => profiler.total_count,
        :failure_ratio => profiler.failure_ratio,
        :max_time => profiler.max_time,
        :avg_time => profiler.avg_time,
        :data => profiler.attributes
      )
      RequestLog::Db.expects(:profiling).returns(profiling)
      profiler.persist!
    end
  end

  describe "persist_enabled" do
    it "defaults to false" do
      profiler.reset.persist_enabled.should == false
    end
    
    it "can be set to true" do
      profiler.persist_enabled = true
      profiler.persist_enabled.should == true      
    end
  end

  describe "should_persist?" do
    before(:each) do
      profiler.persist_enabled = true
    end
    
    it "returns true if total_count % persist_frequency == 0" do
      profiler.persist_frequency = 10
      profiler.success_count = 5
      profiler.failure_count = 5
      profiler.should_persist?.should be_true
      
      profiler.persist_frequency = 3
      profiler.success_count = 80
      profiler.failure_count = 10
      profiler.should_persist?.should be_true      
    end

    it "returns false if total_count % persist_frequency != 0" do
      profiler.persist_frequency = 3
      profiler.success_count = 5
      profiler.failure_count = 5
      profiler.should_persist?.should be_false
    end

    it "returns false if persist_enabled = false" do
      profiler.persist_frequency = 10
      profiler.success_count = 5
      profiler.failure_count = 5
      profiler.persist_enabled = false
      profiler.should_persist?.should be_false
    end    
  end

  describe "attribute_names" do
    it "has accessors" do
      profiler.attribute_names.each do |attribute|
        profiler.send(attribute).should == profiler.default_values[attribute]
        profiler.send("#{attribute}=", "foobar")
        profiler.send(attribute).should == "foobar"        
      end
    end
  end

  describe "attributes" do
    it "returns a hash with the attribute values" do
      profiler.min_time = 3.0
      profiler.attributes.should == profiler.default_values.merge(:min_time => 3.0)
    end
  end

  describe "to_s" do
    it "returns the inspect of the attributes" do
      profiler.to_s.should == profiler.attributes.inspect
    end
  end

  describe "reset" do
    it "resets all attributes to default values" do
      profiler.attribute_names.each do |attribute|
        profiler.send("#{attribute}=", "foobar")
      end
      profiler.reset
      profiler.attribute_names.each do |attribute|
        profiler.send(attribute).should == profiler.default_values[attribute]
      end      
    end
  end
  
  
  
  def profiler
    RequestLog::Profiler
  end
end
