require 'spec_helper'

describe PuppetController do
  login_user

  it "gets servers" do
    get :servers
    assert_response :success
  end

  it "gets classes" do
    get :classes
    assert_response :success
  end

end
