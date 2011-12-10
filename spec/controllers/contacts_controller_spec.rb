require 'spec_helper'

describe ContactsController do
  before do
    controller.session[:user_id] = Factory(:user).id #authentication
  end

  describe "GET /index" do
    before do
      @doe = Contact.create!(:last_name => "Doe")
      @smith = Contact.create!(:last_name => "Smith")
    end

    it "assigns @contacts" do
      get :index
      assigns(:contacts).should eq([@doe, @smith])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end

    it "should filter contacts by name" do
      get :index, :search => "smi"
      assigns(:contacts).should eq([@smith])
    end

    it "should sort contacts correctly" do
      get :index, :sort => "last_name", :direction => "desc"
      assigns(:contacts).should eq([@smith, @doe])
    end
  end
end
