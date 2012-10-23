require 'spec_helper'

describe ServersController do
  login_user

  # ApplicationController tests except those for authentication (tested in authentication_spec.rb)
  # Those tests are here because they're made using other controllers, making sure ApplicationController
  # inherited properties work as expected.
  describe "ApplicationController" do
    render_views

    it "catches exceptions raised when document is not found" do
      # 0             => invalid ObjectId                    => BSON::InvalidObjectId
      # 0000000000000 => valid ObjectId but no document      => Mongoid::Errors::DocumentNotFound
      %w(0 0000000000000).each do |invalid_id|
        get :show, id: invalid_id
        response.status.should == 404
        response.body.should include("These are not the droids you're looking for")
        get :show, id: invalid_id, format: "json"
        response.status.should == 404
        response.body.should be_blank
      end
    end
  end

  describe "real ServersController" do
    let!(:server) { FactoryGirl.create(:server) }

    it "gets index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:servers)
    end
    
    it "gets physical nodes for maintenance" do
      get :index, view_mode: "maintenance"
      assert_response :success
      assert_not_nil assigns(:servers)
      assert_nil assigns(:servers).detect{|m| m.virtual?}
    end
    

    it "gets new" do
      get :new
      assert_response :success
    end

    it "creates server" do
      lambda{ post :create, server: {"name" => "new-server"} }.should change(Server, :count).by(+1)
      assert_redirected_to server_path(assigns(:server))
    end

    it "accepts multi parameter attributes for dates" do
      post :create, server: {"name" => "new-server", "delivered_on(3i)"=>"10", "delivered_on(2i)"=>"12", "delivered_on(1i)"=>"2008" }
      assert_response :redirect
      Server.last.delivered_on.should == Date.new(2008, 12, 10)
    end

    it "shows server" do
      get :show, id: server.id.to_s
      assert_response :success
    end

    it "accesss the xml output" do
      get :show, id: server.id.to_s, format: :xml
      assert_select "server"
    end

    it "gets edit" do
      get :edit, id: server.id.to_s
      assert_response :success
    end

    it "updates server" do
      put :update, id: server.id.to_s, server: { "ipaddresses_attributes"=>[{"address"=>"192.168.99.99", "main"=>"1"}] }
      assert_redirected_to server_path(assigns(:server))
      server.reload
      assert_equal 3232260963, server.read_attribute(:ipaddress)
      assert_equal "192.168.99.99", server.ipaddress
    end

    it "destroys server" do
      lambda{ delete :destroy, id: server.id.to_s }.should change(Server, :count).by(-1)
      assert_redirected_to servers_path
    end
  end
end
