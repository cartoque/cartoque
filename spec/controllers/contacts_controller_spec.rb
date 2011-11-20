require 'spec_helper'

describe ContactsController do
  before do
    controller.session[:user_id] = Factory(:user).id
  end

  describe "GET /index" do
    it "assigns @contacts" do
      contact = Factory(:contact)
      get :index
      assigns(:contacts).should eq([contact])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end
end
