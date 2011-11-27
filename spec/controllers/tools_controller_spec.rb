require 'spec_helper'

describe ToolsController do
  before do
    controller.session[:user_id] = Factory(:user).id #authentication
  end

###  it "should should return a 404 if no tool given" do
###    get :show, :id => :non_existent
###    assert_response 404
###    assert @response.body.include?("These are not the droids you're looking for")
###  end

  it "should should success if tool exists" do
    get :nagios_comparison
    assert_response :success
  end
end
