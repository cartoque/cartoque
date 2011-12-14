require 'spec_helper'

describe Upgrade do
  it "belongs to one server" do
    server = Factory(:server)
    upgrade = Upgrade.create!(:server_id => server.id)
    upgrade.server.should eq server
    server.upgrade.should eq upgrade
  end

  it "should serialize #packages_list" do
    server = Factory(:server)
    upgrade = Upgrade.create!(:server_id => server.id)
    obj = {this: ["is", "a", "test"]}
    upgrade.packages_list = obj
    upgrade.save
    upgrade.reload
    upgrade.packages_list.should eq obj
  end
end
