require 'spec_helper'

describe ConfigurationItem do
  it "should be valid" do
    ConfigurationItem.new.should_not be_valid
    ConfigurationItem.new(:item => Factory(:server)).should be_valid
  end

  describe "ConfigurationItem#identifier" do
    it "should generate the identifier before validations" do
      ci = ConfigurationItem.new(:item => Factory(:server))
      ci.should be_valid
      ci.identifier.should be_present
      ci.save.should be_true
    end

    it "should not fail if #to_s method of real object returns nil" do
      s = Factory(:server)
      s.stub!(:to_s).and_return(nil)
      s.to_s.should be_nil
      ci = ConfigurationItem.new(:item => s)
      ci.should be_valid
      ci.identifier.should_not be_nil
    end

    it "should have a #to_s method in each real-CI-object classes" do
      ActiveRecord::Base.subclasses.each do |klass|
        if klass.instance_methods.include?(:configuration_item)
          #"#{klass}#to_s is not defined (required for playing with ConfigurationItem)"
          klass.should be_instance_method_already_implemented(:to_s)
        end
      end
    end
  end
end
