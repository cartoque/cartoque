require 'spec_helper'

describe PuppetController do
  login_user

  it "should should get servers" do
    get :servers
    assert_response :success
  end

  it "should should get classes" do
    get :classes
    assert_response :success
  end

end
