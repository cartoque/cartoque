require 'spec_helper'

describe ServersController do
  login_user

  # ApplicationController tests except those for authentication (tested in authentication_spec.rb)
  # Those tests are here because they're made using other controllers, making sure ApplicationController
  # inherited properties work as expected.
  describe "ApplicationController" do
    render_views

    describe "catches ActiveRecord::RecordNotFound exceptions" do
      it "and renders a 404 error message when format is html" do
        get :show, :id => 0
        response.status.should == 404
        response.body.should include("These are not the droids you're looking for")
      end

      it "and returns just a head not found for other formats" do
        get :show, :id => 0, :format => "json"
        response.status.should == 404
        response.body.should be_blank
      end
    end
  end

  describe "real ServersController" do
    before do
      @server = Factory(:server)
    end

    it "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:servers)
    end
    
    it "should get physical nodes for maintenance" do
      get :index, :view_mode => "maintenance"
      assert_response :success
      assert_not_nil assigns(:servers)
      assert_nil assigns(:servers).detect{|m| m.virtual?}
    end
    

    it "should get new" do
      get :new
      assert_response :success
    end

    it "should create server" do
      lambda{ post :create, :server => @server.attributes.except(:id).merge("name" => "new-server") }.should change(Server, :count).by(+1)
      assert_redirected_to server_path(assigns(:server))
    end

    it "should show server" do
      get :show, :id => @server.to_param
      assert_response :success
    end

    it "should access the xml output" do
      get :show, :id => @server.to_param, :format => :xml
      assert_select "server"
    end

    it "should get edit" do
      get :edit, :id => @server.to_param
      assert_response :success
    end

    it "should update server" do
      put :update, :id => @server.to_param, :server => @server.attributes.except(:id).merge("ipaddresses_attributes"=>[{"address"=>"192.168.99.99", "main"=>"1"}])
      assert_redirected_to server_path(assigns(:server))
      @server.reload
      assert_equal 3232260963, @server.read_attribute(:ipaddress)
      assert_equal "192.168.99.99", @server.ipaddress
    end

    it "should destroy server" do
      lambda{ delete :destroy, :id => @server.to_param }.should change(Server, :count).by(-1)
      assert_redirected_to servers_path
    end
  end
end
