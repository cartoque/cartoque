require 'spec_helper'

describe BackupExceptionsController do
  login_user

  before do
    @backup_exception = BackupException.create
  end

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backup_exceptions)
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create backup_exception" do
    lambda{ post :create, backup_exception: @backup_exception.attributes }.should change(BackupException, :count)
    assert_redirected_to backup_exceptions_path
  end

  it "should get edit" do
    get :edit, id: @backup_exception.to_param
    assert_response :success
  end

  it "should update backup_exception" do
    put :update, id: @backup_exception.to_param, backup_exception: @backup_exception.attributes
    assert_redirected_to backup_exceptions_path
  end

  it "should destroy backup_exception" do
    lambda{ delete :destroy, id: @backup_exception.to_param }.should change(BackupException, :count).by(-1)
    assert_redirected_to backup_exceptions_path
  end
end
