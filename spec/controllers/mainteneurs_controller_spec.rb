require 'spec_helper'

describe MainteneursController do
  before do
    controller.session[:user_id] = Factory(:user).id #authentication
    @mainteneur = Factory(:mainteneur)
  end

  it "should should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mainteneurs)
  end

  it "should should get new" do
    get :new
    assert_response :success
  end

  it "should should create mainteneur" do
    lambda{ post :create, :mainteneur => @mainteneur.attributes }.should change(Mainteneur, :count)
    assert_redirected_to mainteneur_path(assigns(:mainteneur))
  end

  it "should should show mainteneur" do
    get :show, :id => @mainteneur.to_param
    assert_response :success
  end

  it "should should get edit" do
    get :edit, :id => @mainteneur.to_param
    assert_response :success
  end

  it "should should update mainteneur" do
    put :update, :id => @mainteneur.to_param, :mainteneur => @mainteneur.attributes
    assert_redirected_to mainteneur_path(assigns(:mainteneur))
  end

  it "should should destroy mainteneur" do
    lambda{ delete :destroy, :id => @mainteneur.to_param }.should change(Mainteneur, :count).by(-1)
    assert_redirected_to mainteneurs_path
  end
end
