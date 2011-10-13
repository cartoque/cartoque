require 'spec_helper'

describe PhysicalRack do
  before do
    @rack = Factory(:rack1)
    @site = Factory(:room)
  end

  #TODO: move it to a presenter
  it "should format correctly with #to_s" do
    @rack.to_s.should eq "Rack 1"
    @site.to_s.should eq "Hosting Room 1"
    @rack.site = @site
    @rack.to_s.should eq "Hosting Room 1 - Rack 1"
  end
end
