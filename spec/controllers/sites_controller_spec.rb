require 'spec_helper'

describe SitesController do
  login_user

  before do
    @site = FactoryGirl.create(:room)
  end

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates site" do
    lambda{ post :create, site: { name: "site-01" } }.should change(Site, :count)
    assert_redirected_to sites_path
  end

  it "gets edit" do
    get :edit, id: @site.to_param
    assert_response :success
  end

  it "updates site" do
    put :update, id: @site.to_param, site: @site.attributes
    assert_redirected_to sites_path
  end

  it "destroys site" do
    lambda{ delete :destroy, id: @site.to_param }.should change(Site, :count).by(-1)
    assert_redirected_to sites_path
  end
end
