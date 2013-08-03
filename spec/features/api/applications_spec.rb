require 'spec_helper'

describe "Applications API" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:application) { Application.create!(name: "app-01") }
  let!(:app_instance) { ApplicationInstance.create!(name: "prod", application: application, authentication_method: "none") }

  before { page.set_headers("HTTP_X_API_TOKEN" => user.authentication_token) }
  after { page.set_headers("HTTP_X_API_TOKEN" => nil) }

  describe "GET /applications.json" do
    it "gets all applications" do
      visit applications_path(format: "json")
      page.status_code.should == 200
      res = JSON.parse(page.body) rescue nil
      res.should_not be nil
      res.keys.should == ["applications"]
      res["applications"].should have(1).application
      app = res["applications"].first
      app["name"].should == "app-01"
      app.keys.should_not include "application_instances"
      app["created_at"].should be_present
      app["updated_at"].should be_present
    end
  end

  describe "GET /applications/:id.json" do
    it "shows a specific application" do
      visit application_path(id: application.id.to_s, format: "json")
      page.status_code.should == 200
      res = JSON.parse(page.body) rescue nil
      res.should_not be nil
      res.keys.should == ["application"]
      app = res["application"]
      app["name"].should == "app-01"
      #app.keys.should_not include "application_instances"
      app["created_at"].should be_present
      app["updated_at"].should be_present
    end
  end
end
