require 'spec_helper'

describe MediaDrive do
  it "should be valid with just a name" do
    MediaDrive.new.should_not be_valid
    MediaDrive.new(name: "DVD").should be_valid
  end
end
