require 'spec_helper'

describe "Operating Systems API" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:system) { OperatingSystem.create!(name: "Debian") }

  before { page.set_headers("HTTP_X_API_TOKEN" => user.authentication_token) }
  after { page.set_headers("HTTP_X_API_TOKEN" => nil) }

  describe "GET /operating_systems.json" do
    it "gets all operating_systems" do
      visit operating_systems_path(format: "json")
      page.status_code.should == 200
      res = JSON.parse(page.body) rescue nil
      res.should_not be nil
      res.keys.should == ["operating_systems"]
      res["operating_systems"].should have(1).operating_system
      sys = res["operating_systems"].first
      sys["name"].should == "Debian"
    end
  end

  describe "GET /operating_systems/:id" do
    it "shows a specific operating_system" do
      visit operating_system_path(id: system.id.to_s, format: "json")
      page.status_code.should == 200
      res = JSON.parse(page.body) rescue nil
      res.should_not be nil
      res.keys.should == ["operating_system"]
      sys = res["operating_system"]
      sys["name"].should == "Debian"
    end
  end
end
