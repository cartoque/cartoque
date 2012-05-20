require 'spec_helper'

describe WelcomeController do
  login_user

  it "gets index" do
    get :index
    assert_response :success
  end
end
