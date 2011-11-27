require 'spec_helper'

describe UsersController do
  before do
    controller.session[:user_id] = Factory(:user).id #authentication
    @user = Factory(:bob)
  end

  it "should should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  it "should should get new" do
    get :new
    assert_response :success
  end

  it "should should create user" do
    lambda{ post :create, :user => @user.attributes }.should change(User, :count)
    assert_redirected_to users_path
  end

  it "should should get edit" do
    get :edit, :id => @user.to_param
    assert_response :success
  end

  it "should should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to users_path
  end

  it "should should destroy user" do
    lambda{ delete :destroy, :id => @user.to_param }.should change(User, :count).by(-1)
    assert_redirected_to users_path
  end
end
