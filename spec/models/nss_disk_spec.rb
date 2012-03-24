require 'spec_helper'

describe NssDisk do
  it "should have a server and a name" do
    disk = NssDisk.new
    disk.should_not be_valid
    disk.should have(2).errors
    disk.server = Factory(:mongo_server)
    disk.name = "nss-disk-01"
    disk.should be_valid
  end
end
