require 'spec_helper'

describe BackupJob do
  it "should be valid with just a hierarchy and a server" do
    job = BackupJob.new
    job.should_not be_valid
    job.hierarchy = "/"
    job.server = Factory(:server)
    job.should be_valid
  end
end
