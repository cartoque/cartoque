require 'spec_helper'

describe "Upgrades" do
  let(:user) { FactoryGirl.create(:user) }
  before { login_as user }

  let!(:server1) { Server.create!(name: "server-01") }
  let!(:server2) { Server.create!(name: "server-02") }
  let!(:server3) { Server.create!(name: "server-03") }
  let!(:upgrade1) { Upgrade.create!(server: server1, packages_list: [{ name: "libc" }, { name: "apache2" }]) }
  let!(:upgrade2) { Upgrade.create!(server: server2, packages_list: [{ name: "kernel-3.0" }]) }
  let!(:upgrade3) { Upgrade.create!(server: server3, packages_list: []) }

  describe "GET /upgrades" do
    it "list all upgrades" do
      visit upgrades_path
      page.status_code.should == 200
      page.should have_content "server-01"
      page.should have_content "kernel-3.0"
    end

    it "list upgrades depending on upgrade count" do
      visit upgrades_path(by_any_package: "1")
      page.should_not have_content "server-03"
      visit upgrades_path
      page.should have_content "server-03"
    end

    it "doesn't list upgrades if an exception exists" do
      visit upgrades_path
      page.should have_content "server-01"
      UpgradeExclusion.create!(reason: "Do not upgrade!", server_ids: [server1.id])
      visit upgrades_path
      page.should_not have_content "server-01"
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
  end
end
