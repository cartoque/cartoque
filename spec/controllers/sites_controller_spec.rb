require 'spec_helper'

describe SitesController do
  login_user

  before do
    @site = Factory(:room)
  end

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create site" do
    lambda{ post :create, site: @site.attributes }.should change(Site, :count)
    assert_redirected_to sites_path
  end

  it "should get edit" do
    get :edit, id: @site.to_param
    assert_response :success
  end

  it "should update site" do
    put :update, id: @site.to_param, site: @site.attributes
    assert_redirected_to sites_path
  end

  it "should destroy site" do
    lambda{ delete :destroy, id: @site.to_param }.should change(Site, :count).by(-1)
    assert_redirected_to sites_path
  end
end
