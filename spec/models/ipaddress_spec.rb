require 'spec_helper'

describe Ipaddress do
  it "stores ip address as an integer" do
    ip = Ipaddress.new(address: "127.0.0.1")
    ip.read_attribute(:address).should eq(IPAddr.new("127.0.0.1").to_i)
  end

  it "is able to store large addresses" do
    ip = Ipaddress.new(address: "255.255.255.255")
    ip.read_attribute(:address).should eq(IPAddr.new("255.255.255.255").to_i)
  end

  it "islong to a server" do
    ip = Ipaddress.new(address: "192.168.1.1")
    ip.should_not be_valid
    ip.should have(1).error_on(:server)
    ip.server = FactoryGirl.create(:server)
    ip.should be_valid
  end

  it "leaves ipaddress blank if invalid" do
    ip = Ipaddress.new(address: "abcd", server: FactoryGirl.create(:server))
    ip.should_not be_valid
    ip.address.should be_blank
    ip.address = "192.168.1.1"
    ip.should be_valid
    ip.address.should eq "192.168.1.1"
  end

  context "#to_s" do
    it "returns an empty string if no address" do
      Ipaddress.new(address: "").to_s.should eq("")
    end

    it "includes (vip) if virtual ip" do
      Ipaddress.new(address: "192.168.1.1", virtual: true).to_s.should eq("192.168.1.1 (vip)")
    end

    it "is <strong>'ed if main ip" do
      Ipaddress.new(address: "192.168.1.1", main: true).to_s.should eq("<strong>192.168.1.1</strong>")
    end

    it "returns a human-readable address" do
      ip = Ipaddress.new(address: "127.0.0.1")
      ip.to_s.should eq("127.0.0.1")
    end
  end
end
