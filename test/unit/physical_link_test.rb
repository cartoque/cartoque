require 'test_helper'

class PhysicalLinkTest < ActiveSupport::TestCase
  should "be able to add a physical link to a server" do
    from, to = Factory(:server), Factory(:virtual)
    assert_difference "PhysicalLink.count", +1 do
      from.physical_links = [ PhysicalLink.new(:link_type => "eth", :switch => to) ]
      from.save
    end
  end
end
