require 'spec_helper'

describe "Authentication" do
  after do
    page.set_headers("HTTP_X_API_TOKEN" => nil)
  end

  describe "via a browser" do
    it "redirects on the sign in page if not authenticated" do
      visit servers_path
      current_path.should == new_user_session_path
    end

    it "displays internal auth depending on settings" do
      Setting.allow_internal_authentication.should == "yes"
      visit new_user_session_path
      page.should have_selector("#cas-login")
      page.should have_selector("#internal-login")
      Setting.update_attribute(:allow_internal_authentication, 'no')
      Setting.allow_internal_authentication.should == "no"
      visit new_user_session_path
      page.should have_selector("#cas-login")
      page.should_not have_selector("#internal-login")
    end
  end

  describe "via an API Token" do
    describe "GET /servers.csv", type: :request do
      it "refuses access if no authentication token given" do
        visit servers_path(format: "csv")
        page.status_code.should == 401
      end

      it "refuses access if the given authentication token is wrong (blank, too short)" do
        page.set_headers("HTTP_X_API_TOKEN" => "blah")
        visit servers_path(format: "csv").to_s
        page.status_code.should == 401

        page.set_headers("HTTP_X_API_TOKEN" => "")
        visit servers_path(format: "csv").to_s
        page.status_code.should == 401
      end

      it "grants access if authentication token is valid" do
        u = FactoryGirl.create(:user)
        page.set_headers("HTTP_X_API_TOKEN" => u.authentication_token)
        visit servers_path(format: "csv").to_s
        page.status_code.should == 200
      end

      it "allows access even if not using csv/xml/json formats (changed with devise)" do
        u = FactoryGirl.create(:user)
        page.set_headers("HTTP_X_API_TOKEN" => u.authentication_token)
        visit servers_path(format: "html").to_s
        page.status_code.should == 200
      end

      it "returns an empty body if authorized + RoutingError + json format" do
        u = FactoryGirl.create(:user)
        page.set_headers("HTTP_X_API_TOKEN" => u.authentication_token)
        visit "/serverz.json"
        page.status_code.should == 404
        page.body.should be_blank
      end
    end
  end

  describe "updates User#seen_on (max of #current_sign_in_at and #last_sign_in_at)" do
    it "is unset by default" do
      u = FactoryGirl.create(:user)
      u.seen_on.should be_blank
    end

    it "updates when using 'current_user' and returns the current user" do
      u = FactoryGirl.create(:user)
      page.set_headers("HTTP_X_API_TOKEN" => u.authentication_token)
      visit servers_path(format: "csv").to_s
      page.status_code.should == 200
      u.reload.seen_on.should_not be_blank
      (u.seen_on.to_date - Date.today).should be < 2
    end
  end

  describe "redirection after sign in" do
    let!(:user) { FactoryGirl.create(:user, email: "john@example.net", password: "foobar") }

    before do
      Setting.update_attribute(:allow_internal_authentication, 'yes')
    end

    it "redirects back to root path if no back url given" do
      visit new_user_session_path

      within "#internal-login" do
        fill_in 'user_email', with: 'john@example.net'
        fill_in 'user_password', with: 'foobar'
        click_button 'Sign in'
      end

      current_path.should == root_path
    end

    it "redirects back to stored location if any" do
      visit servers_path
      current_path.should == new_user_session_path

      within "#internal-login" do
        fill_in 'user_email', with: 'john@example.net'
        fill_in 'user_password', with: 'foobar'
        click_button 'Sign in'
      end

      current_path.should == servers_path
    end
  end
end
