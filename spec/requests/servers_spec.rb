require 'spec_helper'

describe "Servers" do
  let(:user) { FactoryGirl.create(:user) }
  let!(:server) { Server.create!(name: "srv-01") }
  let(:application) { Application.create!(name: "app-01") }
  let(:app_instance) { ApplicationInstance.create!(name: "prod", application: application) }

  before do
    login_as user
  end

  describe "GET /servers" do
    it "gets all servers" do
      visit servers_path
      page.status_code.should be 200
      page.should have_content "srv-01"
    end
  end

  describe "GET /servers/:id" do
    it "shows a server page" do
      visit server_path(server)
      page.should have_selector "h1", text: /Server.* SRV-01/
    end
  end

  describe "GET /servers/new" do
    it "creates a new server" do
      visit new_server_path
    end
  end

  describe "GET /servers/:id/edit" do
    it "edits a server" do
      visit edit_server_path(server)
      fill_in "server_name", with: "server-01"
      click_button "Apply modifications"
      current_path.should == server_path(server.reload)
      page.should have_content "SERVER-01"
    end
  end
end
