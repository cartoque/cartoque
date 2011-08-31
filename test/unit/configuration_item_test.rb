require 'test_helper'

class ConfigurationItemTest < ActiveSupport::TestCase
  should "be valid" do
    assert ! ConfigurationItem.new.valid?
    assert ConfigurationItem.new(:item => Factory(:server)).valid?
  end

  context "#identifier" do
    should "not raise if there's no item (other validations will fail in this case)" do
      ci = ConfigurationItem.new
      assert ! ci.valid?
    end

    should "generate the identifier before validations" do
      ci = ConfigurationItem.new(:item => Factory(:server))
      assert ci.valid?
      assert_not_nil ci.identifier
      assert ci.save
    end
  end
end
