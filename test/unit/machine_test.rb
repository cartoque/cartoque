require 'test_helper'

class MachineTest < ActiveSupport::TestCase
  should "be valid" do
    assert ! Machine.new.valid?
    assert Machine.new(:name => "my-server").valid?
  end

  context "#ipaddress" do
    setup do
      @machine = Factory(:machine)
    end

    should "return ipaddress" do
      assert_equal "192.168.0.10", @machine.ipaddress
      #IPAddr.new("192.168.0.10").to_i => 3232235530
      assert_equal 3232235530, @machine.read_attribute(:ipaddress)
    end

    should "updates with an address as a string" do
      @machine.ipaddress = "192.168.99.99"
      @machine.save
      @machine.reload
      assert_equal 3232260963, @machine.read_attribute(:ipaddress)
      assert_equal "192.168.99.99", @machine.ipaddress
    end

    should "updates with an address as an number between 1 and 32" do
      @machine.ipaddress = "24"
      assert_equal "255.255.255.0", @machine.ipaddress
    end

    should "not update if IP is invalid" do
      @machine.ip = "192.168.0AAA.11"
      assert_equal "192.168.0.10", @machine.ip
    end
  end

  context "details" do
    setup do
      @machine = Factory(:machine)
    end

    should "display cpu" do
      assert_equal "4 * 4 cores, 3.2 GHz<br />(Xeon 2300)", @machine.cpu
    end

    should "display ram" do
      assert_equal "42", @machine.ram
    end

    should "display disks" do
      assert_equal "5 * 13G (SAS)", @machine.disks
    end
  end
end
