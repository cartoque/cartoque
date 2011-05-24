require 'test_helper'

class MachineTest < ActiveSupport::TestCase
  should "be valid" do
    assert ! Machine.new.valid?
    assert Machine.new(:name => "my-server").valid?
  end

  context "#ip" do
    setup do
      @machine = Factory(:machine)
    end

    should "return sousreseau and lastbyte" do
      assert_equal "192.168.0.10", @machine.ip
    end

    should "update correctly" do
      @machine.ip = "192.168.0.11"
      assert_equal "192.168.0.11", @machine.ip
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
