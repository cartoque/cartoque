require 'spec_helper'

describe NssVolume do
  it "should have a name at least" do
    disk = NssVolume.new
    server = Factory(:server)
    disk.should_not be_valid
    disk.should have(1).error
    disk.name = "nss-vol-01"
    disk.should be_valid
    disk.clients = [server]
    disk.save
    disk.should be_persisted
    disk.reload.client_ids.should eq [server.id]
  end
end
  
