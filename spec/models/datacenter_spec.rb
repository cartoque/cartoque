require 'spec_helper'

describe Datacenter do
  describe "#default" do
    it "returns first datacenter if any" do
      Datacenter.count.should == 0
      Datacenter.create!(:name => "Hosterz")
      Datacenter.default.name.should == "Hosterz"
    end

    it "should generate a default datacenter if none" do
      Datacenter.count.should == 0
      dc = Datacenter.default
      dc.should_not be_blank
      dc.name.should == "Datacenter"
    end
  end
end
