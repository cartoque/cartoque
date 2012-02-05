require 'spec_helper'

describe SaasController do
  login_user

  it "should should get show" do
    get :show, :id => :redmine
    assert_response :success
  end
end
