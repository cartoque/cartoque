require 'spec_helper'

describe OperatingSystemsController do
  login_user

  before do
    @operating_system = Factory(:operating_system)
  end

  it "should should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:operating_systems)
  end

  it "should should get new" do
    get :new
    assert_response :success
  end

  it "should should create operating_system" do
    lambda{ post :create, :operating_system => @operating_system.attributes }.should change(OperatingSystem, :count)
    assert_redirected_to operating_systems_path
  end

  it "should should get edit" do
    get :edit, :id => @operating_system.to_param
    assert_response :success
  end

  it "should should update operating_system" do
    put :update, :id => @operating_system.to_param, :operating_system => @operating_system.attributes
    assert_redirected_to operating_systems_path
  end

  it "should should destroy operating_system" do
    lambda{ delete :destroy, :id => @operating_system.to_param }.should change(OperatingSystem, :count).by(-1)
    assert_redirected_to operating_systems_path
  end
end
