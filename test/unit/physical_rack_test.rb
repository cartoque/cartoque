require 'test_helper'

class PhysicalRackTest < ActiveSupport::TestCase
  setup do
    @rack = Factory(:rack1)
    @site = Factory(:room)
  end

  test "to_s is in the form 'site.name' + ' - ' + 'name'" do
    assert_equal "Rack 1", @rack.to_s
    assert_equal "Hosting Room 1", @site.to_s
    @rack.site = @site
    assert_equal "Hosting Room 1 - Rack 1", @rack.to_s
  end
end
