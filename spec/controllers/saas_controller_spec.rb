require 'spec_helper'

describe SaasController do
  before do
    controller.session[:user_id] = Factory(:user).id #authentication
  end

  it "should should get show" do
    get :show, :id => :redmine
    assert_response :success
  end
end
