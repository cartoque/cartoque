require 'spec_helper'

describe ApplicationInstance do
  it "should have a name, an authentication method and an application" do
    instance = ApplicationInstance.new
    instance.should_not be_valid
    instance.should have(3).errors
    instance.name = "prod"
    instance.application_id = Factory(:application).id
    instance.authentication_method = "none"
    instance.should be_valid
  end
end
