require 'spec_helper'

describe RequestLog::Db do
  describe "mongo_db" do
    it "can be set to som custom Mongo DB" do
      RequestLog::Db.mongo_db = "foobar"
      RequestLog::Db.mongo_db.should == "foobar"
    end
    
    it "is defaulted to a MongoHQ database if MONGOHQ_URL is set" do
      ENV['MONGOHQ_URL'] = "mongodb://app269330:w761lfkslzsen4bm5g2gf7@flame.mongohq.com:27070/app269330"
      RequestLog::Db.mongo_db = nil
      db = RequestLog::Db.mongo_db
      db.is_a?(Mongo::DB).should be_true
      db.connection.is_a?(Mongo::Connection).should be_true
      db.connection.auths.first['db_name'].should == "app269330"
    end
    
    it "is nil of MONGOHQ_URL is not set" do
      ENV['MONGOHQ_URL'] = nil
      RequestLog::Db.mongo_db = nil
      RequestLog::Db.mongo_db.should be_nil
    end
  end
end
