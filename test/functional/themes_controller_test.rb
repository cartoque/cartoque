require 'test_helper'

class ThemesControllerTest < ActionController::TestCase
  setup do
    @theme = Factory(:theme)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:themes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create theme" do
    assert_difference('Theme.count') do
      post :create, :theme => @theme.attributes
    end

    assert_redirected_to themes_path
  end

  test "should get edit" do
    get :edit, :id => @theme.to_param
    assert_response :success
  end

  test "should update theme" do
    put :update, :id => @theme.to_param, :theme => @theme.attributes
    assert_redirected_to themes_path
  end

  test "should destroy theme" do
    assert_difference('Theme.count', -1) do
      delete :destroy, :id => @theme.to_param
    end

    assert_redirected_to themes_path
  end
end
