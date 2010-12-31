require 'test_helper'

class StoragesControllerTest < ActionController::TestCase
  setup do
    @storage = storages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storage" do
    assert_difference('Storage.count') do
      post :create, :storage => @storage.attributes
    end

    assert_redirected_to storage_path(assigns(:storage))
  end

  test "should show storage" do
    get :show, :id => @storage.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @storage.to_param
    assert_response :success
  end

  test "should update storage" do
    put :update, :id => @storage.to_param, :storage => @storage.attributes
    assert_redirected_to storage_path(assigns(:storage))
  end

  test "should destroy storage" do
    assert_difference('Storage.count', -1) do
      delete :destroy, :id => @storage.to_param
    end

    assert_redirected_to storages_path
  end
end
