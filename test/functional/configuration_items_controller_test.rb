require 'test_helper'

class ConfigurationItemsControllerTest < ActionController::TestCase
  setup do
    @configuration_item = Factory(:configuration_item)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:configuration_items)
  end

  test "should show configuration_item" do
    get :show, id: @configuration_item.to_param
    assert_response :success
  end
end
