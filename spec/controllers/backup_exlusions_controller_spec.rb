require 'spec_helper'

describe BackupExclusionsController do
  login_user

  before do
    @backup_exclusion = BackupExclusion.create
  end

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backup_exclusions)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates backup_exclusion" do
    lambda{ post :create, backup_exclusion: { reason: "Here a good reason" } }.should change(BackupExclusion, :count)
    assert_redirected_to backup_exclusions_path
  end

  it "gets edit" do
    get :edit, id: @backup_exclusion.to_param
    assert_response :success
  end

  it "updates backup_exclusion" do
    put :update, id: @backup_exclusion.to_param, backup_exclusion: @backup_exclusion.attributes
    assert_redirected_to backup_exclusions_path
  end

  it "destroys backup_exclusion" do
    lambda{ delete :destroy, id: @backup_exclusion.to_param }.should change(BackupExclusion, :count).by(-1)
    assert_redirected_to backup_exclusions_path
  end
end
