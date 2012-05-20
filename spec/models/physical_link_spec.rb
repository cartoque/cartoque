require 'spec_helper'

describe PhysicalLink do
  it "is able to add a physical link to a server" do
    from, to = FactoryGirl.create(:server), FactoryGirl.create(:virtual)
    lambda do
      PhysicalLink.create(server: from, switch: to, link_type: "eth")
    end.should change(PhysicalLink, :count).by(+1)
  end
end
