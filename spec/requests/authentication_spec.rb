require 'spec_helper'

describe "Authentication" do
  describe "via an API Token" do
    describe "GET /servers.csv", :type => :request do
      it "refuses access if no authentication token given" do
        get servers_path(format: "csv")
        response.status.should == 401
      end

      it "refuses access if the given authentication token is wrong (blank, too short)" do
        get servers_path(:format => "csv").to_s, {}, "HTTP_X_API_TOKEN" => "blah"
        response.status.should == 401

        get servers_path(:format => "csv").to_s, {}, "HTTP_X_API_TOKEN" => ""
        response.status.should == 401
      end

      it "grants access if authentication token is valid" do
        u = Factory(:user)
        get servers_path(:format => "csv").to_s, {}, "HTTP_X_API_TOKEN" => u.authentication_token
        response.status.should == 200
      end

      it "allows access even if not using csv/xml/json formats (changed with devise)" do
        u = Factory(:user)
        get servers_path(:format => "html").to_s, {}, "HTTP_X_API_TOKEN" => u.authentication_token
        response.status.should == 200
      end
    end
  end

  describe "should update User#seen_on (max of #current_sign_in_at and #last_sign_in_at)" do
    it "is unset by default" do
      u = Factory(:user)
      u.seen_on.should be_blank
    end

    it "updates when using 'current_user' and returns the current user" do
      u = Factory(:user)
      get servers_path(:format => "csv").to_s, {}, "HTTP_X_API_TOKEN" => u.authentication_token
      response.status.should == 200
      u.reload.seen_on.should_not be_blank
      (u.seen_on.to_date - Date.today).should be < 2
    end
  end
end
