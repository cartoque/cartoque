require 'spec_helper'

describe PhysicalRacksController do
  before do
    controller.session[:user_id] = Factory(:user).id #authentication
    @physical_rack = Factory(:rack1)
  end

  it "should should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:physical_racks)
  end

  it "should should get new" do
    get :new
    assert_response :success
  end

  it "should should create physical_rack" do
    lambda{ post :create, :physical_rack => @physical_rack.attributes }.should change(PhysicalRack, :count)
    assert_redirected_to physical_racks_path
  end

  it "should should get edit" do
    get :edit, :id => @physical_rack.to_param
    assert_response :success
  end

  it "should should update physical_rack" do
    put :update, :id => @physical_rack.to_param, :physical_rack => @physical_rack.attributes
    assert_redirected_to physical_racks_path
  end

  it "should should destroy physical_rack" do
    lambda{ delete :destroy, :id => @physical_rack.to_param }.should change(PhysicalRack, :count).by(-1)
    assert_redirected_to physical_racks_path
  end
end
