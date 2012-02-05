require 'spec_helper'

describe "I18n" do
  describe "when not authenticated" do
    it "leaves I18n.locale to 'en' if no HTTP header available", :type => :request do
      I18n.default_locale.should eq :en
      get "/users/sign_in"
      controller.current_user.should be_blank
      I18n.locale.should eq :en
    end

    it "sets I18n.locale to HTTP_ACCEPT_LANGUAGE header first 2 letters if provided and locale exists" do
      get "/users/sign_in", {}, "HTTP_ACCEPT_LANGUAGE" => "bleh"
      I18n.locale.should eq :en
      get "/users/sign_in", {}, "HTTP_ACCEPT_LANGUAGE" => "fr"
      I18n.locale.should eq :fr
      get "/users/sign_in", {}, "HTTP_ACCEPT_LANGUAGE" => "french"
      I18n.locale.should eq :fr
    end
  end

  describe "when authenticated" do
    before do
      @controller = ApplicationsController.new
      @controller.request    = ActionController::TestRequest.new
    end

    it "takes the locale if possible" do
      I18n.locale = I18n.default_locale
      I18n.locale.should_not eq :fr
      user = Factory(:user)
      user.update_setting(:locale, "fr")
      @controller.stub(:current_user).and_return(user)
      @controller.send(:set_locale)
      I18n.locale.should eq :fr
    end
  end
end
