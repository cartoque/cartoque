require 'spec_helper'

describe MongoServer do
  it "should be valid with just a name" do
    MongoServer.new.should_not be_valid
    MongoServer.new(name: "my-server").should be_valid
  end
end
