require 'spec_helper'

describe CronjobsController do
  login_user

  render_views

  describe "GET /index" do
    it "should not display any cronjob if no filter set" do
      get :index
      assert_select "td[colspan=5]", 1
    end

    it "should display cronjobs if server is set" do
      server = Server.create!(name: "my-server")
      Cronjob.create!(definition_location: "/etc/cron.d/crontask", hierarchy: "/",
                      frequency: "* * * * *", server_id: server.id.to_s, command: "/bin/ls")
      server.reload.cronjobs.count.should == 1
      get :index, by_server: server.id
      assert_select "td[colspan=5]", 0
      assert_select "td", server.name
    end
  end
end
