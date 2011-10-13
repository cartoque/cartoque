require 'spec_helper'

describe PhysicalLink do
  it "should be able to add a physical link to a server" do
    from, to = Factory(:server), Factory(:virtual)
    lambda do
      from.physical_links = [ PhysicalLink.new(:link_type => "eth", :switch => to) ]
      from.save
    end.should change(PhysicalLink, :count).by(+1)
  end
end
