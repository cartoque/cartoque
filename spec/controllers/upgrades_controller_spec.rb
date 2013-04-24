require 'spec_helper'

describe UpgradesController do
  login_user

  let(:server1) { Server.create!(name: "server-01") }
  let(:upgrade1) { Upgrade.create!(server: server1, packages_list: [{ name: "libc" }, { name: "apache2" }]) }

  describe "PUT validate" do
    it "validates an upgrade" do
      put :validate, id: upgrade1, format: :js
    end
  end

  describe "PUT update" do
    it "changes the rebootable flag" do
      upgrade1.rebootable.should eq true
      put :update, id: upgrade1, upgrade: { rebootable: "0" }, format: :js
      upgrade1.reload.rebootable.should eq false
      put :update, id: upgrade1, upgrade: { rebootable: "1" }, format: :js
      upgrade1.reload.rebootable.should eq true
    end
  end
end
