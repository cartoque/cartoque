require 'spec_helper'

describe "Servers" do
  let(:user) { FactoryGirl.create(:user) }
  let!(:server) { FactoryGirl.create(:server, name: "srv-01") }
  let(:application) { Application.create!(name: "app-01") }
  let(:app_instance) { ApplicationInstance.create!(name: "prod", application: application) }
  let(:datacenter) { FactoryGirl.create(:datacenter) }
  let(:foreign_datacenter) { FactoryGirl.create(:datacenter, name: "Tokyo") }

  before do
    login_as user
  end

  describe "GET /servers" do
    it "gets all servers" do
      visit servers_path
      page.status_code.should be 200
      page.should have_content "srv-01"
    end

    it "only sees servers in visible_datacenters or without datacenter" do
      user.update_attribute(:visible_datacenter_ids, [datacenter.id])
      server2 = FactoryGirl.create(:server, name: "srv-02",
                                            datacenter_ids: [datacenter.id])
      server3 = FactoryGirl.create(:server, name: "srv-03",
                                            datacenter_ids: [foreign_datacenter.id])
      visit servers_path
      page.status_code.should be 200
      page.should have_content "srv-01" #no datacenter
      page.should have_content "srv-02" #datacenter, ok
      page.should_not have_content "srv-03" #datacenter, not visible
    end
  end

  describe "GET /servers/:id" do
    it "shows a server page" do
      visit server_path(server)
      page.should have_selector "h1", text: /Server.* srv-01/
    end

    it "does not access servers to foreign datacenters" do
      user.update_attribute(:visible_datacenter_ids, [datacenter.id])
      server3 = FactoryGirl.create(:server, name: "srv-03",
                                            datacenter_ids: [FactoryGirl.create(:datacenter, name: "Tokyo").id])
      visit server_path(server3)
      page.status_code.should be 404
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
      page.should have_content "server-01"
    end
  end
end
