require 'spec_helper'

describe SettingsController do
  login_user

  it "should get index" do
    get :index
    assert_response :success
  end

  it "should get update_all" do
    put :update_all, settings: { "site_announcement_message" => "Site in maintenance mode" }
    assert_redirected_to settings_path
    assert_equal "Site in maintenance mode", Setting.site_announcement_message

    put :update_all, settings: { "site_announcement_message" => "" }
    assert_redirected_to settings_path
    assert_equal "", Setting.site_announcement_message
  end

end
