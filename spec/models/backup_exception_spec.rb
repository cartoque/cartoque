require 'spec_helper'

describe BackupException do
  pending "has many servers" do
    srv = Factory.create(:server)
    exception = BackupException.create(reason: "Here's why !")
    exception.server_ids = [srv.id]
    exception.save
    exception.reload.server_ids.should == [srv.id]
    exception.reload.servers.should == [srv]
  end
end
