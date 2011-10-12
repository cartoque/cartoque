require 'spec_helper'

describe Ipaddress do
  it "should store ip address as an integer" do
    ip = Ipaddress.new(:address => "127.0.0.1")
    ip.read_attribute(:address).should eq(IPAddr.new("127.0.0.1").to_i)
  end

  it "should be able to store large addresses" do
    ip = Ipaddress.new(:address => "255.255.255.255")
    ip.read_attribute(:address).should eq(IPAddr.new("255.255.255.255").to_i)
  end

  it "should belong to a server"

  it "should have a valid ip address"

  context "#to_s" do
    it "should return an empty string if no address" do
      ip = Ipaddress.new(:address => "")
      ip.to_s.should eq("")
    end

    pending "should include (vip) if virtual ip"

    pending "should be <strong>'ed if main ip"

    it "should return a human-readable address" do
      ip = Ipaddress.new(:address => "127.0.0.1")
      ip.to_s.should eq("127.0.0.1")
    end
  end
end
