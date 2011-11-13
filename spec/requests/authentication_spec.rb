require 'spec_helper'

describe "Authentication" do
  describe "via an API Token" do
    describe "GET /servers.csv", :type => :request do
      it "refuses access if no authentication token given" do
        get servers_path(format: "csv")
        response.should redirect_to(auth_required_path)
      end

      it "refuses access if the given authentication token is wrong (blank, too short)" do
        get servers_path(:format => "csv").to_s, {}, "HTTP_X_CARTOCS_TOKEN" => "blah"
        response.should redirect_to(auth_required_path)

        get servers_path(:format => "csv").to_s, {}, "HTTP_X_CARTOCS_TOKEN" => ""
        response.should redirect_to(auth_required_path)
      end

      it "grants access if authentication token is valid" do
        u = Factory(:user)
        get servers_path(:format => "csv").to_s, {}, "HTTP_X_CARTOCS_TOKEN" => u.authentication_token
        response.status.should be(200)
      end
    end
  end

  describe "should update User#seen_on attribute" do
    it "is unset by default" do
      u = Factory(:user)
      u.seen_on.should be_blank
    end

    it "updates when using 'current_user' and returns the current user" do
      u = Factory(:user)
      get servers_path(:format => "csv").to_s, {}, "HTTP_X_CARTOCS_TOKEN" => u.authentication_token
      current_user = controller.send(:current_user)
      current_user.should eq u
      current_user.seen_on.should_not be_blank
      (current_user.seen_on - Date.today).should be < 2
    end
  end
end
