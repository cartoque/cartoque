require 'spec_helper'

describe ApplicationUrl do
  before do
    @app = Application.create(name: "app-01")
    @inst = ApplicationInstance.new(name: "prod", application: @app)
  end

  it "shouldn't be valid if not in an ApplicationInstance" do
    ApplicationUrl.new(url: "http://www.example.com/").should_not be_valid
    ApplicationUrl.new(url: "http://www.example.com/", application_instance: @inst).should be_valid
  end

  it "shouldn't create an empty url" do
    ApplicationUrl.new(url: "", application_instance: @inst).should_not be_valid
  end
end
