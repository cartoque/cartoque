require 'spec_helper'

describe ConfigurationItemsController do
  login_user

  before do
    @configuration_item = Factory(:configuration_item)
  end

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:configuration_items)
  end

  it "should show configuration_item" do
    get :show, id: @configuration_item.to_param
    assert_response :success
  end
end
