require 'spec_helper'

describe Site do
  it "should be valid with just a name" do
    site = Site.new
    site.should_not be_valid
    site.name = "room-1"
    site.should be_valid
  end

  it "can have one or many racks" do
    site = Site.create(name: "room-1")
    rack = FactoryGirl.create(:rack1)
    rack.site = site
    rack.save
    rack.site.should eq site
    site.physical_racks.to_a.should eq [ rack ]
  end

  it "updates rack's site_name" do
    site = Site.create!(name: "room-1")
    rack = PhysicalRack.create!(name: "rack-one", site: site)
    srv =  Server.create!(name: "srv", physical_rack: rack)
    rack.site_name.should == "room-1"

    site.name = "room-one"
    site.save
    rack.reload.site_name.should == "room-one"
    srv.reload.physical_rack_full_name.should == "room-one - rack-one"

    site.destroy
    rack.reload.site_name.should == nil
    srv.reload.physical_rack_full_name.should == "rack-one"
  end
end
