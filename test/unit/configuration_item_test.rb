require 'test_helper'

class ConfigurationItemTest < ActiveSupport::TestCase
  should "be valid" do
    assert ! ConfigurationItem.new.valid?
    assert ConfigurationItem.new(:item => Factory(:server)).valid?
  end
end
