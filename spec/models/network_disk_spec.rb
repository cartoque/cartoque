require 'spec_helper'

describe NetworkDisk do
  it "should have a server and a client" do
    netdisk = NetworkDisk.new
    netdisk.should_not be_valid
    netdisk.should have(2).errors
    netdisk.errors.keys.sort.should eq [:client, :server]
    netdisk.client = Factory(:mongo_virtual)
    netdisk.server = Factory(:mongo_server)
    netdisk.should be_valid
  end
end
