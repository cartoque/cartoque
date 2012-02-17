require 'spec_helper'

describe PhysicalRack do
  before do
    @rack = Factory(:rack1)
    @site = Factory(:room)
  end

  #TODO: move it to a presenter
  describe "#to_s" do
    it "should format correctly with #to_s" do
      @rack.to_s.should eq "Rack 1"
      @site.to_s.should eq "Hosting Room 1"
      @rack.site_id = @site.id
      @rack.save
      @rack.to_s.should eq "Hosting Room 1 - Rack 1"
    end
  end

  describe "#stock?" do
    it "should return true only if rack is marked as stock" do
      PhysicalRack.new(:name => "stock", :status => PhysicalRack::STATUS_STOCK).stock?.should be_true
    end
  end
end
