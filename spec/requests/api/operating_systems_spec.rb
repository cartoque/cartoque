require 'spec_helper'

describe "Operating Systems API" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:system) { OperatingSystem.create!(name: "Debian") }

  describe "GET /operating_systems.json" do
    it "gets all operating_systems" do
      get operating_systems_path(format: "json").to_s, {}, "HTTP_X_API_TOKEN" => user.authentication_token
      response.status.should == 200
      res = JSON.parse(response.body) rescue nil
      res.should_not be nil
      res.keys.should == ["operating_systems"]
      res["operating_systems"].should have(1).operating_system
      sys = res["operating_systems"].first
      sys["name"].should == "Debian"
    end
  end

  describe "GET /operating_systems/:id" do
    it "shows a specific operating_system" do
      get operating_system_path(id: system.id.to_s, format: "json").to_s,
          {}, "HTTP_X_API_TOKEN" => user.authentication_token
      response.status.should == 200
      res = JSON.parse(response.body) rescue nil
      res.should_not be nil
      res.keys.should == ["operating_system"]
      sys = res["operating_system"]
      sys["name"].should == "Debian"
    end
  end
end
