require 'test_helper'

class MachineTest < ActiveSupport::TestCase
  should "be valid" do
    assert Machine.new.valid?
  end

  context "#ip" do
    should "return sousreseau and quatr_octet" do
      assert_equal "192.168.0.10", machines(:one).ip
    end

    should "update correctly" do
      machines(:one).ip = "192.168.0.11"
      assert_equal "192.168.0.11", machines(:one).ip
    end

    should "not update if IP is invalid" do
      machines(:one).ip = "192.168.0AAA.11"
      assert_equal "192.168.0.10", machines(:one).ip
    end
  end
end
