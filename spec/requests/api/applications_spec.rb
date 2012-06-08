require 'spec_helper'

describe "Applications API" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:application) { Application.create!(name: "app-01") }
  let!(:app_instance) { ApplicationInstance.create!(name: "prod", application: application, authentication_method: "none") }

  describe "GET /applications.json" do
    it "gets all applications" do
      get applications_path(format: "json").to_s, {}, "HTTP_X_API_TOKEN" => user.authentication_token
      response.status.should == 200
      res = JSON.parse(response.body) rescue nil
      res.should_not be nil
      res.keys.should == ["applications"]
      res["applications"].should have(1).application
      app = res["applications"].first
      app["name"].should == "app-01"
      app.keys.should_not include "application_instances"
    end
  end

  describe "GET /applications/:id.json" do
    it "shows a specific application" do
      get application_path(id: application.id.to_s, format: "json").to_s,
          {}, "HTTP_X_API_TOKEN" => user.authentication_token
      response.status.should == 200
      res = JSON.parse(response.body) rescue nil
      res.should_not be nil
      res.keys.should == ["application"]
      app = res["application"]
      app["name"].should == "app-01"
      #app.keys.should_not include "application_instances"
    end
  end
end
