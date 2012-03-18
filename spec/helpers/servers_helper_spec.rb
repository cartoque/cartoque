require 'spec_helper'

describe ServersHelper do
  it "should render options for location filter" do
    @site1 = Site.create!(name: "eu-west")
    @site2 = Site.create!(name: "us-east")
    @rack1 = PhysicalRack.create!(name: "rack-1-eu", site_id: @site1.id.to_s)
    @rack2 = PhysicalRack.create!(name: "rack-2-us", site_id: @site2.id.to_s)
    text = options_for_location_filter("rack-#{@rack2.id}")
    text.should have_selector :css, "option[value='']", ""
    text.should have_selector :css, "option[value='site-#{@site1.id}']", @site1.name
    text.should have_selector :css, "option[value='rack-#{@rack1.id}']", "&nbsp; #{@rack1}"
  end
end
