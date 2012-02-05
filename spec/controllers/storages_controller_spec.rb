require 'spec_helper'

describe StoragesController do
  login_user

  before do
    @storage = Factory(:storage)
  end

  it "should should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storages)
  end

  it "should should get new" do
    get :new
    assert_response :success
  end

  it "should should create storage" do
    lambda{ post :create, :storage => @storage.attributes }.should change(Storage, :count)
    assert_redirected_to storages_path
  end

  it "should should show storage" do
    get :show, :id => @storage.to_param
    assert_response :success
  end

  it "should should get edit" do
    get :edit, :id => @storage.to_param
    assert_response :success
  end

  it "should should update storage" do
    put :update, :id => @storage.to_param, :storage => @storage.attributes
    assert_redirected_to storages_path
  end

  it "should should destroy storage" do
    lambda{ delete :destroy, :id => @storage.to_param }.should change(Storage, :count).by(-1)
    assert_redirected_to storages_path
  end
end
