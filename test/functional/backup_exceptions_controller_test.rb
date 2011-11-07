require 'test_helper'

class BackupExceptionsControllerTest < ActionController::TestCase
  setup do
    @backup_exception = backup_exceptions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backup_exceptions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create backup_exception" do
    assert_difference('BackupException.count') do
      post :create, backup_exception: @backup_exception.attributes
    end

    assert_redirected_to backup_exception_path(assigns(:backup_exception))
  end

  test "should show backup_exception" do
    get :show, id: @backup_exception.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @backup_exception.to_param
    assert_response :success
  end

  test "should update backup_exception" do
    put :update, id: @backup_exception.to_param, backup_exception: @backup_exception.attributes
    assert_redirected_to backup_exception_path(assigns(:backup_exception))
  end

  test "should destroy backup_exception" do
    assert_difference('BackupException.count', -1) do
      delete :destroy, id: @backup_exception.to_param
    end

    assert_redirected_to backup_exceptions_path
  end
end
