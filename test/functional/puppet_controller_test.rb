require 'test_helper'

class PuppetControllerTest < ActionController::TestCase
  test "should get servers" do
    get :servers
    assert_response :success
  end

  test "should get classes" do
    get :classes
    assert_response :success
  end

end
