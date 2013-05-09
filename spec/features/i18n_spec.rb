require 'spec_helper'

describe "I18n" do
  describe "when not authenticated" do
    after { page.set_headers("HTTP_ACCEPT_LANGUAGE" => nil) }

    it "leaves I18n.locale to 'en' if no HTTP header available", type: :request do
      I18n.default_locale.should eq :en
      visit "/users/sign_in"
      I18n.locale.should eq :en
    end

    it "sets I18n.locale to HTTP_ACCEPT_LANGUAGE header first 2 letters if provided and locale exists" do
      page.set_headers("HTTP_ACCEPT_LANGUAGE" => "bleh")
      visit "/users/sign_in"
      I18n.locale.should eq :en

      page.set_headers("HTTP_ACCEPT_LANGUAGE" => "fr")
      visit "/users/sign_in"
      I18n.locale.should eq :fr

      page.set_headers("HTTP_ACCEPT_LANGUAGE" => "french")
      visit "/users/sign_in"
      I18n.locale.should eq :fr
    end
  end

  describe "when authenticated" do
    before do
      @user = FactoryGirl.create(:user)
      @controller = ApplicationsController.new
      @controller.request    = ActionController::TestRequest.new
      @controller.stub(:current_user).and_return(@user)
      I18n.locale = I18n.default_locale
    end

    it "takes the locale if possible" do
      I18n.locale.should_not eq :fr
      @user.update_setting("locale", "fr")
      @controller.send(:set_locale)
      I18n.locale.should eq :fr
    end

    it "doesn't take user locale if it's invalid" do
      I18n.locale.should eq :en
      @user.update_setting("locale", "bl")
      @controller.send(:set_locale)
      I18n.locale.should eq :en
      @user.update_setting("locale", "")
      @controller.send(:set_locale)
      I18n.locale.should eq :en
    end
  end
end
