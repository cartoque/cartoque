require 'test_helper'

class MachineTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Machine.new.valid?
  end

  def test_ip
    assert_equal "192.168.0.10", machines(:one).ip
  end
end
