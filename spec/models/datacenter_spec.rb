require 'spec_helper'

describe Datacenter do
  it "has a name" do
    Datacenter.new.should_not be_valid
    Datacenter.new(name: "Blah").should be_valid
  end

  it "has a unique name across the instance" do
    Datacenter.create!(name: "Datacenter")
    dc = Datacenter.new(name: "Datacenter")
    dc.should_not be_valid
    dc.errors.keys.should == [:name]
  end

  describe "#default" do
    it "returns first datacenter if any" do
      Datacenter.count.should == 0
      Datacenter.create!(name: "Hosterz")
      Datacenter.default.name.should == "Hosterz"
    end

    it "generates a default datacenter if none" do
      Datacenter.count.should == 0
      dc = Datacenter.default
      dc.should_not be_blank
      dc.name.should == "Datacenter"
    end
  end
end
