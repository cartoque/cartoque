require 'test_helper'

class MachinesControllerTest < ActionController::TestCase
  setup do
    @machine = Factory(:machine)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:machines)
  end
  
  test "should get physical nodes for maintenance" do
    get :index, :view_mode => "maintenance"
    assert_response :success
    assert_template 'maintenance'
    assert_not_nil assigns(:machines)
    assert_nil assigns(:machines).detect{|m| m.virtual?}
  end
  

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create machine" do
    assert_difference('Machine.count') do
      post :create, :machine => @machine.attributes
    end

    assert_redirected_to machine_path(assigns(:machine))
  end

  test "should show machine" do
    get :show, :id => @machine.to_param
    assert_response :success
  end

  test "should access the xml output" do
    get :show, :id => @machine.to_param, :format => :xml
    assert_select "machine"
  end

  test "should get edit" do
    get :edit, :id => @machine.to_param
    assert_response :success
  end

  test "should update machine" do
    put :update, :id => @machine.to_param, :machine => @machine.attributes.merge("ipaddress"=>"192.168.99.99")
    assert_redirected_to machine_path(assigns(:machine))
    @machine.reload
    assert_equal 3232260963, @machine.read_attribute(:ipaddress)
    assert_equal "192.168.99.99", @machine.ipaddress
  end

  test "should destroy machine" do
    assert_difference('Machine.count', -1) do
      delete :destroy, :id => @machine.to_param
    end

    assert_redirected_to machines_path
  end
end
