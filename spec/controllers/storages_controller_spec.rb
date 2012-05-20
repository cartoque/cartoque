require 'spec_helper'

describe StoragesController do
  login_user

  let!(:storage) { FactoryGirl.create(:storage) }

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storages)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates storage" do
    lambda{ post :create, storage: { constructor: "IBM", server_id: FactoryGirl.create(:virtual).id.to_s } }.should change(Storage, :count)
    assert_redirected_to storages_path
  end

  it "shows storage" do
    get :show, id: storage.to_param
    assert_response :success
  end

  it "gets edit" do
    get :edit, id: storage.to_param
    assert_response :success
  end

  it "updates storage" do
    put :update, id: storage.to_param, storage: storage.attributes
    assert_redirected_to storages_path
  end

  it "destroys storage" do
    lambda{ delete :destroy, id: storage.to_param }.should change(Storage, :count).by(-1)
    assert_redirected_to storages_path
  end
end
