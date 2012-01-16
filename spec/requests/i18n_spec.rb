require 'spec_helper'

describe "I18n" do
  describe "when not authenticated" do
    it "leaves I18n.locale to 'en' if no HTTP header available", :type => :request do
      I18n.default_locale.should eq :en
      get "/auth/required"
      controller.send(:current_user).should be_blank
      I18n.locale.should eq :en
    end

    it "sets I18n.locale to HTTP_ACCEPT_LANGUAGE header first 2 letters if provided and locale exists" do
      get "/auth/required", {}, "HTTP_ACCEPT_LANGUAGE" => "bleh"
      I18n.locale.should eq :en
      get "/auth/required", {}, "HTTP_ACCEPT_LANGUAGE" => "fr"
      I18n.locale.should eq :fr
      get "/auth/required", {}, "HTTP_ACCEPT_LANGUAGE" => "french"
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
      @controller.session[:user_id] = user.id #authentication
      user.update_setting(:locale, "fr")
      @controller.send(:current_user).should_not be_blank
      @controller.send(:set_locale)
      I18n.locale.should eq :fr
    end
  end
end
