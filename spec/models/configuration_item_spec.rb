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
  end

  describe "concrete classes" do
    before do
      Dir.glob(Rails.root.join('app/models/*')).each{|f| require f}
    end

    it "should have a #to_s method in each real-CI-object classes" do
      ActiveRecord::Base.subclasses.each do |klass|
        if klass.reflect_on_all_associations.detect{|a|a.name == :configuration_item && a.macro == :has_one}
          #"#{klass}#to_s is not defined (required for playing with ConfigurationItem)"
          klass.instance_methods.should include(:to_s)
        end
      end
    end

    it "should match classes observed in ConfigurationItemsObserver" do
      classes_with_configuration_item = ActiveRecord::Base.subclasses.select do |klass|
        klass.reflect_on_all_associations.detect{|a|a.name == :configuration_item && a.macro == :has_one}
      end.map(&:name).sort
      observed_classes = ConfigurationItemsObserver.instance.observed_classes.map(&:name).sort
      classes_with_configuration_item.should eq observed_classes
    end
  end
end
