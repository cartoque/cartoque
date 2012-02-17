require 'spec_helper'

describe LicensesController do
  login_user

  before do
    @license = License.create(:editor => "WorldSoft")
  end

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:licenses)
  end

  it "should create license" do
    lambda{ post :create, license: @license.attributes }.should change(License, :count)
    assert_redirected_to licenses_path
  end

  it "should get edit" do
    get :edit, id: @license.to_param
    assert_response :success
  end

  it "should update license" do
    put :update, id: @license.to_param, license: @license.attributes
    assert_redirected_to licenses_path
  end

  it "should destroy license" do
    lambda{ delete :destroy, id: @license.to_param }.should change(License, :count).by(-1)
    assert_redirected_to licenses_path
  end
end
