require 'spec_helper'

describe SessionsController do
  before do
    controller.session[:user_id] = Factory(:user).id #authentication
  end

  it "should access unprotected page even if not logged in" do
    get :unprotected
    assert_response :success
  end
end
