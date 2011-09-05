require 'test_helper'

class PhysicalLinkTest < ActiveSupport::TestCase
  should "be able to add a physical link to a server" do
    from, to = Factory(:server), Factory(:virtual)
    to.physical_links = [ PhysicalLink.new(:switch => to) ]
    assert_difference "PhysicalLink.count", +1 do
      assert to.save
    end
  end
end
