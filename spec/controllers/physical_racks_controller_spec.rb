require 'spec_helper'

describe PhysicalRacksController do
  login_user

  before do
    @physical_rack = FactoryGirl.create(:rack1)
  end

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:physical_racks)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates physical_rack" do
    lambda{ post :create, physical_rack: { name: "rack-01" } }.should change(PhysicalRack, :count)
    assert_redirected_to physical_racks_path
  end

  it "gets edit" do
    get :edit, id: @physical_rack.to_param
    assert_response :success
  end

  it "updates physical_rack" do
    put :update, id: @physical_rack.to_param, physical_rack: @physical_rack.attributes
    assert_redirected_to physical_racks_path
  end

  it "destroys physical_rack" do
    lambda{ delete :destroy, id: @physical_rack.to_param }.should change(PhysicalRack, :count).by(-1)
    assert_redirected_to physical_racks_path
  end
end
