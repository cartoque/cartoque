require 'spec_helper'

describe Upgrade do
  before do
    @server = Factory(:server)
    @upgrade = Upgrade.create!(:server_id => @server.id)
  end

  it "belongs to one server" do
    @upgrade.server.should eq @server
    @server.upgrade.should eq @upgrade
  end

  it "should serialize #packages_list" do
    obj = [ {name: "libc6"}, {name: "kernel"}]
    @upgrade.packages_list = obj
    @upgrade.save
    @upgrade.reload
    @upgrade.packages_list.should eq obj
  end

  it "updates counts when updating packages list" do
    @upgrade.packages_list.should be_blank
    @upgrade.count_total.should eq 0
  end

  it "has an upgrader" do
    user = Factory(:user)
    @upgrade.upgrader_id = user.id
    @upgrade.save
    @upgrade.reload.upgrader.should eq user
  end
end
