require 'test_helper'

class MachineTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Machine.new.valid?
  end
end
