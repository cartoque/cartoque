require 'spec_helper'

describe SettingsController do
  render_views
  login_user

  it "GET /settings" do
    get :index
    assert_response :success
  end

  it "PUT /settings/update_all" do
    put :update_all, settings: { "site_announcement_message" => "Site in maintenance mode" }
    assert_redirected_to settings_path
    assert_equal "Site in maintenance mode", Setting.site_announcement_message

    put :update_all, settings: { "site_announcement_message" => "" }
    assert_redirected_to settings_path
    assert_equal "", Setting.site_announcement_message
  end

  it "GET /settings/edit_visibility" do
    get :edit_visibility, back_url: 'blah', format: 'js'
    response.should be_success
    response.body.should include "Change visible datacenters"
    response.body.should include "/settings/update_visibility?back_url=blah"
  end

  describe "PUT /settings/update_visibility" do
    it "resets visible datacenters without parameters" do
      put :update_visibility, back_url: '/settings'
      response.should redirect_to '/settings'
      @user.reload.visible_datacenters.should be_empty
    end

    it "sets visible datacenters for current user" do
      datacenter = FactoryGirl.create(:datacenter)
      put :update_visibility, back_url: '/settings', visible_datacenter_ids: [datacenter.id.to_s]
      response.should redirect_to '/settings'
      @user.reload.visible_datacenters.should == [datacenter]
    end
  end
end
