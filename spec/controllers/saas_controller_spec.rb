require 'spec_helper'

describe SaasController do
  login_user

  it "gets show" do
    get :show, id: :redmine
    assert_response :success
  end
end
