require 'spec_helper'

describe "Servers" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as user
    @srv = Server.create!(name: "srv-01")
  end

  describe "GET /servers" do
    it "gets all servers" do
      get servers_path
      response.status.should be 200
      response.body.should include "srv-01"
    end
  end

  describe "GET /servers/:id" do
    it "shows a server page" do
      get server_path(@srv)
      response.body.should have_selector "h2", content: "Server SRV-01"
    end
  end
end
