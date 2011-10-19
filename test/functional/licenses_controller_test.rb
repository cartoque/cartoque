require 'test_helper'

class LicensesControllerTest < ActionController::TestCase
  setup do
    @license = licenses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:licenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create license" do
    assert_difference('License.count') do
      post :create, license: @license.attributes
    end

    assert_redirected_to license_path(assigns(:license))
  end

  test "should show license" do
    get :show, id: @license.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @license.to_param
    assert_response :success
  end

  test "should update license" do
    put :update, id: @license.to_param, license: @license.attributes
    assert_redirected_to license_path(assigns(:license))
  end

  test "should destroy license" do
    assert_difference('License.count', -1) do
      delete :destroy, id: @license.to_param
    end

    assert_redirected_to licenses_path
  end
end
