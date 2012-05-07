require 'spec_helper'

describe BackupExclusion do
  it "has many servers" do
    srv = FactoryGirl.create(:server)
    exception = BackupExclusion.create(reason: "Here's why !")
    exception.server_ids = [srv.id]
    exception.save
    exception.reload.server_ids.should == [srv.id]
    exception.reload.servers.should == [srv]
  end
end
