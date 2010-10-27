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
