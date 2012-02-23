require 'spec_helper'

describe UsersController do
  login_user

  before do
    @user = Factory(:bob)
  end

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create user" do
    lambda{ post :create, :user => {"name"=>"john"} }.should change(User, :count)
    assert_redirected_to users_path
  end

  it "should get edit" do
    get :edit, :id => @user.to_param
    assert_response :success
  end

  it "should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to users_path
  end

  it "should destroy user" do
    lambda{ delete :destroy, :id => @user.to_param }.should change(User, :count).by(-1)
    assert_redirected_to users_path
  end
end
