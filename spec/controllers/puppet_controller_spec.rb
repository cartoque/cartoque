require 'spec_helper'

describe PuppetController do
  before do
    controller.session[:user_id] = Factory(:user).id #authentication
  end

  it "should should get servers" do
    get :servers
    assert_response :success
  end

  it "should should get classes" do
    get :classes
    assert_response :success
  end

end
