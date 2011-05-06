require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  should "access unprotected page even if not logged in" do
    get :unprotected
    assert_response :success
  end
end
