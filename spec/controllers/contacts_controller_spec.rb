require 'spec_helper'

describe ContactsController do
  login_user

  describe "GET /index" do
    before do
      @doe = Contact.create!(:last_name => "Doe")
      @smith = Contact.create!(:last_name => "Smith")
    end

    it "assigns @contacts" do
      get :index
      assigns(:contacts).to_a.should eq [@doe, @smith]
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end

    it "should filter contacts by name" do
      get :index, :search => "smi"
      assigns(:contacts).to_a.should eq [@smith]
    end

    it "should sort contacts correctly" do
      get :index, :sort => "last_name", :direction => "desc"
      assigns(:contacts).to_a.should eq [@smith, @doe]
    end

    describe "with internal visibility" do
      before do
        @bob = Contact.create!(:last_name => "Bob", :internal => true)
        @vendor = Company.create!(:name => "Manufacturer inc.")
        @team = Company.create!(:name => "Our team (internal)", :internal => true)
      end

      it "shouldn't display internal contacts/companies by default" do
        get :index
        assigns(:contacts).to_a.should_not include @bob
        assigns(:companies).to_a.should include @vendor
        assigns(:companies).to_a.should_not include @team
      end

      it "should display internal contacts/companies with some more params or session" do
        get :index, :with_internals => "1"
        assigns(:contacts).to_a.should include @bob
        assigns(:companies).to_a.should include @team
        #and keep it in session...
        controller.send(:current_user).settings["contacts_view_internals"].should eq "1"
        get :index
        assigns(:contacts).to_a.should include @bob
        assigns(:companies).to_a.should include @team
      end
    end
  end
end
