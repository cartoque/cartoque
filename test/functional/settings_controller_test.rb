require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get update_all" do
    put :update_all, :settings => { "site_announcement_message" => "Site in maintenance mode" }
    assert_redirected_to settings_path
    assert_equal "Site in maintenance mode", Setting.find_by_key("site_announcement_message").value

    put :update_all, :settings => { "site_announcement_message" => "" }
    assert_redirected_to settings_path
    assert_equal "", Setting.find_by_key("site_announcement_message").value
  end

end
