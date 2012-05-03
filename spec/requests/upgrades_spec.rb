require 'spec_helper'

describe "Upgrades" do
  let(:user) { FactoryGirl.create(:user) }
  before { login_as user }

  let!(:server1) { Server.create!(name: "server-01") }
  let!(:server2) { Server.create!(name: "server-02") }
  let!(:upgrade1) { Upgrade.create!(server: server1, packages_list: [{ name: "libc" }, { name: "apache2" }]) }
  let!(:upgrade2) { Upgrade.create!(server: server2, packages_list: [{ name: "kernel-3.0" }]) }

  describe "GET /upgrades" do
    it "list all upgrades" do
      visit upgrades_path
      page.status_code.should == 200
      page.should have_content "server-01"
      page.should have_content "kernel-3.0"
    end

    it "sorts upgrades by server name and packages count" do
      visit upgrades_path
      click_link "Name"
      current_path.should == upgrades_path
      page.body.should match /server-01.*server-02/m
      click_link "Count"
      current_path.should == upgrades_path
      page.body.should match /server-02.*server-01/m #count asc, server2=>1, server1=>2
      click_link "Count"
      current_path.should == upgrades_path
      page.body.should match /server-01.*server-02/m #count desc, server1=>2, server2=>1
    end

    it "validates an upgrade" do
      put validate_upgrade_path(upgrade1, format: :js)
    end
  end
end
