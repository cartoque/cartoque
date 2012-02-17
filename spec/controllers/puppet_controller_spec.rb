require 'spec_helper'

describe PuppetController do
  login_user

  it "should get servers" do
    get :servers
    assert_response :success
  end

  it "should get classes" do
    get :classes
    assert_response :success
  end

end
