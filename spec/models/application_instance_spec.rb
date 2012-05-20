require 'spec_helper'

describe ApplicationInstance do
  it "has a name, an authentication method and an application" do
    instance = ApplicationInstance.new
    instance.should_not be_valid
    instance.errors.messages.keys.sort.should == [:application, :authentication_method, :name]
    instance.should have(4).errors
    instance.name = "prod"
    instance.application = FactoryGirl.create(:application)
    instance.authentication_method = "none"
    instance.should be_valid
  end
end
