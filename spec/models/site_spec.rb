require 'spec_helper'

describe Site do
  it "should be valid with just a name" do
    site = Site.new
    site.should_not be_valid
    site.name = "room-1"
    site.should be_valid
  end

  it "can have one or many racks" do
    site = Site.new(:name => "room-1")
    rack = Factory(:rack1)
    site.physical_racks = [ rack ]
    site.save
    rack.site.should eq site
    site.physical_racks.should eq [ rack ]
  end
end
