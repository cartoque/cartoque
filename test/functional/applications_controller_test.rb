require 'test_helper'

class ApplicationsControllerTest < ActionController::TestCase
  setup do
    @controller = ApplicationsController.new
    @controller.stubs(:current_user).returns(User.new)
    @request    = ActionController::TestRequest.new
    @request.stubs(:local?).returns(true)
    @application = Factory(:application)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:applications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create application" do
    assert_difference('Application.count') do
      post :create, :application => @application.attributes
    end

    assert_redirected_to application_path(assigns(:application))
  end

  test "should show application" do
    get :show, :id => @application.to_param
    assert_response :success
  end

  test "should access the rest/xml API" do
    app_inst = ApplicationInstance.new(:name => "prod", :authentication_method => "none")
    app_inst.machines = [ Factory(:machine), Factory(:virtual) ]
    @application.application_instances = [ app_inst ]
    @application.save
    get :show, :id => @application.to_param, :format => :xml
    assert_select "application>id", "#{@application.id}"
    assert_equal 1, @application.application_instances.count
    assert_select "application>application-instances>application-instance", 1
    assert_equal 2, @application.application_instances.first.machines.count
    assert_select "application>application-instances>application-instance>machines>machine", 2
  end

  test "should access an application through its identifier" do
    get :show, :id => @application.identifier, :format => :xml
    assert_select "application>id", "#{@application.id}"
  end

  test "should access the API without authentication" do
    @controller.stubs(:current_user).returns(nil)
    get :show, :id => @application.identifier, :format => "xml"
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @application.to_param
    assert_response :success
  end

  test "should update application" do
    put :update, :id => @application.to_param, :application => @application.attributes
    assert_redirected_to application_path(assigns(:application))
  end

  test "should destroy application" do
    assert_difference('Application.count', -1) do
      delete :destroy, :id => @application.to_param
    end

    assert_redirected_to applications_path
  end
end
