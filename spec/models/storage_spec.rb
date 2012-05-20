require 'spec_helper'

describe Storage do
  it "is valid with just a constructor and a server" do
    storage = Storage.new
    storage.should_not be_valid
    storage.should have(2).errors
    storage.server = FactoryGirl.create(:server)
    storage.constructor = "IBM"
    storage.should be_valid
  end
end
