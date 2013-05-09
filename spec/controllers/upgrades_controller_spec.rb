require 'spec_helper'

describe UpgradesController do
  login_user

  let!(:server1) { Server.create!(name: "server-01") }
  let!(:upgrade1) { Upgrade.create!(server: server1, packages_list: [{ name: "libc" }, { name: "apache2" }]) }

  describe "GET index" do
    render_views

    it "lists upgrades" do
      get :index
      response.should be_success
      response.body.should include "apache2"
    end

    it "gets back_url right on post-its" do
      get :index
      response.should be_success
      response.body.should include %(<a href="/postits/new?back_url=%2Fupgrades&amp;commentable_id=#{upgrade1.id}&amp;commentable_type=Upgrade" class="postit-link")
    end
  end

  describe "PUT validate" do
    it "validates an upgrade" do
      put :validate, id: upgrade1, format: :js
    end
  end

  describe "PUT update" do
    render_views

    # NB: inherited_resources now caches params in a request, so you cannot have a test
    # with two different params hashes (didn't dug too deep into this for now)
    it "sets the rebootable flag to false" do
      upgrade1.update_attribute(:rebootable, true)
      upgrade1.rebootable.should eq true
      put :update, id: upgrade1, upgrade: { rebootable: "0" }, format: :js
      upgrade1.reload.rebootable.should eq false
    end

    # NB: inherited_resources now caches params in a request, so you cannot have a test
    # with two different params hashes (didn't dug too deep into this for now)
    it "sets the rebootable flag to true" do
      upgrade1.update_attribute(:rebootable, false)
      upgrade1.rebootable.should eq false
      put :update, id: upgrade1, upgrade: { rebootable: "1" }, format: :js
      upgrade1.reload.rebootable.should eq true
    end

    it "gets back_url right on post-its" do
      put :update, id: upgrade1, upgrade: { rebootable: "0" }, format: :js, back_url: "foo"
      response.should be_success
      response.body.should include %(<a href=\\"/postits/new?back_url=foo)
    end
  end
end
