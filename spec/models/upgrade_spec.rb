require 'spec_helper'

describe Upgrade do
  it "belongs to one server" do
    server = Factory(:server)
    upgrade = Upgrade.create!(:server_id => server.id)
    upgrade.server.should eq server
    server.upgrade.should eq upgrade
  end
end
