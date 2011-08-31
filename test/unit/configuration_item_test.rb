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

    should "have a #to_s method in each real-CI-object classes" do
      ActiveRecord::Base.subclasses.each do |klass|
        if klass.instance_methods.include?(:configuration_item)
          assert klass.instance_method_already_implemented?(:to_s), "#{klass}#to_s is not defined (required for playing with ConfigurationItem)"
        end
      end
    end
  end
end
