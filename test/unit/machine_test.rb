require 'test_helper'

class MachineTest < ActiveSupport::TestCase
  should "be valid" do
    assert ! Machine.new.valid?
    assert Machine.new(:nom => "my-server").valid?
  end

  context "#ip" do
    setup do
      @machine = Factory(:machine)
    end

    should "return sousreseau and quatr_octet" do
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
end
