require 'test_helper'

class ServersHelperTest < ActionView::TestCase
  should "render options for location filter" do
    @site1 = Site.create!(:name => "eu-west")
    @site2 = Site.create!(:name => "us-east")
    @rack1 = PhysicalRack.create!(:name => "rack-1-eu", :site_id => @site1.id)
    @rack2 = PhysicalRack.create!(:name => "rack-2-us", :site_id => @site2.id)
    render :text => options_for_location_filter("rack:#{@rack2.id}")
    assert_select "option[value=]", ""
    assert_select "option[value=site:#{@site1.id}]", @site1.name
    assert_select "option[value=rack:#{@rack1.id}]", "&nbsp; #{@rack1}"
  end
end
