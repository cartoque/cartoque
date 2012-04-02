require 'spec_helper'

describe Upgrade do
  let(:server) { FactoryGirl.create(:server) }
  let(:upgrade) { Upgrade.create!(server_id: server.id) }

  it "belongs to one server" do
    upgrade.server.should eq server
    server.reload.upgrade.should eq upgrade
  end

  it "should have a server" do
    Upgrade.new.should_not be_valid
    Upgrade.new(server: FactoryGirl.create(:virtual)).should be_valid
  end

  it "should store #packages_list as a Hash" do
    obj = [ {"name" => "libc6"}, {"name" => "kernel"}]
    upgrade.packages_list = obj
    upgrade.save
    upgrade.reload
    upgrade.packages_list.should eq obj
  end

  it "updates counts when updating packages list" do
    upgrade.packages_list.should be_blank
    upgrade.count_total.should eq 0
  end

  it "has an upgrader" do
    user = FactoryGirl.create(:user)
    upgrade.upgrader_id = user.id
    upgrade.save
    upgrade.reload.upgrader.should eq user
  end
end
