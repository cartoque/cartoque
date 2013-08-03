require 'spec_helper'

describe "Servers API" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:server) { Server.create!(name: "srv-01") }
  let(:application) { Application.create!(name: "app-01") }
  let(:app_instance) { ApplicationInstance.create!(name: "prod", application: application) }

  before { page.set_headers("HTTP_X_API_TOKEN" => user.authentication_token) }
  after { page.set_headers("HTTP_X_API_TOKEN" => nil) }

  describe "GET /servers.json" do
    it "gets all servers" do
      visit servers_path(format: "json")
      page.status_code.should == 200
      res = JSON.parse(page.body) rescue nil
      res.should_not be nil
      res.keys.should == ["servers"]
      res["servers"].should have(1).server
      srv = res["servers"].first
      srv["name"].should == "srv-01"
      srv["created_at"].should be_present
      srv["updated_at"].should be_present
    end
  end

  describe "GET /servers/:id" do
    it "shows a specific server" do
      visit server_path(id: server.id.to_s, format: "json")
      page.status_code.should == 200
      res = JSON.parse(page.body) rescue nil
      res.should_not be nil
      res.keys.should == ["server"]
      srv = res["server"]
      srv["name"].should == "srv-01"
      srv["created_at"].should be_present
      srv["updated_at"].should be_present
    end
  end
end
