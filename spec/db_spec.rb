require 'spec_helper'

describe RequestLog::Db do
  describe "mongo_db" do
    it "can be set to som custom Mongo DB" do
      RequestLog::Db.mongo_db = "foobar"
      RequestLog::Db.mongo_db.should == "foobar"
    end
  end
end
