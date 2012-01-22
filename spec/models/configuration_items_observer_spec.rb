require 'spec_helper'

describe ConfigurationItemsObserver do
  it "should have a CI object" do
    s = Server.new(:name => "my-new-server")
    s.should be_valid
    s.configuration_item.should_not be_blank
    lambda { s.save }.should change(ConfigurationItem, :count).by(+1)
    s.should be_persisted
    s.reload.configuration_item.should be_present
  end

  it "should preserve associations defined before save" do
    a = Application.new(:name => "webapp-01")
    c = Contact.create(:last_name => "Doe")
    a.contact_ids = [c.id]
    a.save
    a.reload.contact_ids.should eq [c.id]
  end

  it "should add a CI when #ci method is called" do
    s = Server.new(:name => "my-new-server")
    s.should be_valid
    s.configuration_item.should_not be_blank
    s.configuration_item.should_not be_persisted
    s.configuration_item.should_not be_blank
    lambda { s.save }.should change(ConfigurationItem, :count).by(+1)
    s.should be_persisted
    s.reload.configuration_item.should be_persisted
  end

  it "should update its CI when a concrete-CI-object with an existing CI is updated" do
    s = Server.create(:name => "my-new-server")
    s.should be_persisted
    s.reload.configuration_item.should_not be_nil
    s.configuration_item.identifier.should eq "server::my-new-server" 
    s.name = "new-name"
    lambda { s.save! }.should_not change(ConfigurationItem, :count)
    s.reload.configuration_item.identifier.should eq "server::new-name"
  end

  it "should destroy its CI if real-CI-object is destroyed" do
    s = Server.create(:name => "my-new-server")
    s.should be_persisted
    s.reload.configuration_item.should_not be_nil
    lambda { s.destroy }.should change(ConfigurationItem, :count).by(-1)
  end

  it "should not bother if a model isn't a concrete-CI-object" do
    s = Setting.new(:key => "dummy")
    lambda { s.save! }.should_not change(ConfigurationItem, :count)
  end

  it "should not generate the CI twice, in any case" do
    s = Server.new(:name => "my-new-server")
    lambda { s.save! }.should change(ConfigurationItem, :count).by(+1)
    lambda { s.save! }.should_not change(ConfigurationItem, :count)
  end
end
