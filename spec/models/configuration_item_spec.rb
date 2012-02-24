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

###  describe "#contact*_with_role" do
###    before do
###      @ci = ConfigurationItem.create(item: Factory(:application))
###      @co = Contact.create(last_name: "Cruise")
###      @ro = Role.create(name: "Ninja")
###      @cr = ContactRelation.create(configuration_item_id: @ci.id, contact_id: @co.id, role_id: @ro.id)
###    end

###    it "returns contact relations who have the given role" do
###      @ci.contact_relations_with_role(@ro).should == [@cr]
###      @ci.contact_relations_with_role(@ro).should == [@cr]
###    end

###    it "returns contacts who have the given role id" do
###      @ci.contacts_with_role(@ro.id).should == [@co]
###      @ci.contact_ids_with_role(@ro.id).should == [@co.id]
###    end

###    it "returns contacts who have the give role if role given" do
###      @ci.contacts_with_role(@ro).should == [@co]
###      @ci.contact_ids_with_role(@ro).should == [@co.id]
###    end

###    it "returns contacts without role if no valid role given" do
###      @ci.contacts_with_role(nil).should == []
###      @ci.contacts_with_role(0).should == []
###    end
###  end

###  describe "#contact_ids_with_role=" do
###    before do
###      @ci = ConfigurationItem.create(item: Factory(:application))
###      @co = Contact.create(last_name: "Cruise")
###      @ro = Role.create(name: "Ninja")
###    end

###    it "adds and remove necessary contact relations" do
###      @ci.contacts_with_role(@ro).should be_blank

###      @ci.contact_ids_with_role=({@ro.id => [@co.id]})
###      @ci.contact_ids_with_role(@ro).should eq [@co.id]

###      @ci.contact_ids_with_role=({@ro.id => []})
###      @ci.contact_ids_with_role(@ro).should eq []
###    end

###    it "removes contacts if a given role key is not present" do
###      @ci.contact_ids_with_role=({@ro.id => [@co.id]})
###      @ci.contact_ids_with_role(@ro).should eq [@co.id]
###      @ci.contact_ids_with_role=({})
###      @ci.contact_ids_with_role(@ro).should eq []
###    end

###    it "shouldn't change contact_relations if no change is made" do
###      @ci.contact_ids_with_role=({@ro.id => [@co.id]})
###      crs = @ci.contact_relations_with_role(@ro).map(&:id)
###      crs.should have(1).item

###      lambda { @ci.contact_ids_with_role=({@ro.id => [@co.id]}) }.should_not change(ContactRelation, :count)
###      @ci.contact_relations_with_role(@ro).map(&:id).should == crs
###    end
###  end
end
