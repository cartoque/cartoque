require 'spec_helper'

describe PhysicalRack do
  before do
    @rack = FactoryGirl.create(:rack1)
    @site = FactoryGirl.create(:room)
  end

  #TODO: move it to a presenter
  describe "#fullname" do
    it "should format correctly with #fullname or #to_s" do
      @rack.to_s.should eq "Rack 1"
      @site.to_s.should eq "Hosting Room 1"
      @rack.site = @site
      @rack.save
      @rack.to_s.should eq "Hosting Room 1 - Rack 1"
    end
  end

  describe "#site_name" do
    it "is a denormalized version of #site.try(:name)" do
      @rack.site_name.should be_blank

      @rack.update_attribute(:site_id, @site.id)
      @rack.reload.site_name.should == "Hosting Room 1"

      @site.reload.update_attribute(:name, "Room 1")
      @rack.reload.site_name.should == "Room 1"

      @site.destroy
      @rack.reload.site_name.should be_blank
    end
  end

  describe "#stock?" do
    it "should return true only if rack is marked as stock" do
      PhysicalRack.new(name: "stock", status: PhysicalRack::STATUS_STOCK).stock?.should be_true
    end
  end
end
