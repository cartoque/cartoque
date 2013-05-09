require 'spec_helper'

describe "Puppet" do
  let(:user) { FactoryGirl.create(:user) }
  before { login_as user }

  let!(:server1) { Server.create!(name: "server-01", puppetversion: "2.6") }
  let!(:server2) { Server.create!(name: "server-02") }

  describe "GET /puppet/servers" do
    it "list all servers with puppet enabled" do
      visit "/puppet/servers"
      page.status_code.should == 200
      page.should have_content "server-01"
      page.should have_content "server-02"
    end

    it "filters servers by puppet status" do
      visit "/puppet/servers?by_puppet=1"
      page.should have_content "server-01"
      page.should_not have_content "server-02"
    end
  end
end
