require 'test_helper'

class MainteneursControllerTest < ActionController::TestCase
  setup do
    @mainteneur = Factory(:mainteneur)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mainteneurs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mainteneur" do
    assert_difference('Mainteneur.count') do
      post :create, :mainteneur => @mainteneur.attributes
    end
    assert_redirected_to mainteneur_path(assigns(:mainteneur))
  end

  test "should show mainteneur" do
    get :show, :id => @mainteneur.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @mainteneur.to_param
    assert_response :success
  end

  test "should update mainteneur" do
    put :update, :id => @mainteneur.to_param, :mainteneur => @mainteneur.attributes
    assert_redirected_to mainteneur_path(assigns(:mainteneur))
  end

  test "should destroy mainteneur" do
    assert_difference('Mainteneur.count', -1) do
      delete :destroy, :id => @mainteneur.to_param
    end
    assert_redirected_to mainteneurs_path
  end
end
