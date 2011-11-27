require 'spec_helper'

describe TomcatsController do
  before do
    controller.session[:user_id] = Factory(:user).id #authentication
  end

  it "should should get index" do
    get :index
    assert_response :success
  end
end
