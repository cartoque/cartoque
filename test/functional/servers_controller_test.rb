require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  setup do
    @server = Factory(:server)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:servers)
  end
  
  test "should get physical nodes for maintenance" do
    get :index, :view_mode => "maintenance"
    assert_response :success
    assert_template 'maintenance'
    assert_not_nil assigns(:servers)
    assert_nil assigns(:servers).detect{|m| m.virtual?}
  end
  

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create server" do
    assert_difference('Server.count') do
      post :create, :server => @server.attributes.merge("name" => "new-server")
    end

    assert_redirected_to server_path(assigns(:server))
  end

  test "should show server" do
    get :show, :id => @server.to_param
    assert_response :success
  end

  test "should access the xml output" do
    get :show, :id => @server.to_param, :format => :xml
    assert_select "server"
  end

  test "should get edit" do
    get :edit, :id => @server.to_param
    assert_response :success
  end

  test "should update server" do
    put :update, :id => @server.to_param, :server => @server.attributes.merge("ipaddresses_attributes"=>[{"address"=>"192.168.99.99", "main"=>"1"}])
    assert_redirected_to server_path(assigns(:server))
    @server.reload
    assert_equal 3232260963, @server.read_attribute(:ipaddress)
    assert_equal "192.168.99.99", @server.ipaddress
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete :destroy, :id => @server.to_param
    end

    assert_redirected_to servers_path
  end
end
