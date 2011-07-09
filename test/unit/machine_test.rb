require 'test_helper'

class MachineTest < ActiveSupport::TestCase
  should "be valid" do
    assert ! Machine.new.valid?
    assert Machine.new(:name => "my-server").valid?
  end

  context "#ipaddresses" do
    setup do
      @machine = Factory(:machine)
    end

    should "update with an address as a string" do
      @machine.ipaddresses = [ Ipaddress.new(:address => "192.168.99.99", :main => true) ]
      @machine.save
      @machine.reload
      assert_equal 3232260963, @machine.read_attribute(:ipaddress)
      assert_equal "192.168.99.99", @machine.ipaddress
    end

    should "update with an address as a number between 1 and 32" do
      @machine.ipaddresses = [ Ipaddress.new(:address => "24", :main => true) ]
      @machine.save
      assert_equal 1, @machine.reload.ipaddresses.count
      assert_equal "255.255.255.0", @machine.ipaddresses.first.address
      assert_equal 4294967040, @machine.read_attribute(:ipaddress)
      assert_equal "255.255.255.0", @machine.ipaddress
    end

    should "leave ip empty if no main ipaddress" do
      @machine.ipaddresses = [ Ipaddress.new(:address => "24", :main => true) ]
      @machine.save
      assert_not_nil @machine.reload.ipaddress
      @machine.ipaddresses = [ Ipaddress.new(:address => "24") ]
      @machine.save
      assert_nil @machine.reload.ipaddress
      @machine.ipaddresses = [ ]
      @machine.save
      assert_nil @machine.reload.ipaddress
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
