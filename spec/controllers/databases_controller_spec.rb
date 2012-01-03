require 'spec_helper'

describe DatabasesController do
  
  # This should return the minimal set of attributes required to create a valid
  # Database. As you add validations to Database, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:name => "db-01", :database_type => "postgres"}
  end

  before do
    controller.session[:user_id] = Factory(:user).id #authentication
    @database = Factory(:database)
  end

  describe "GET index" do
    it "assigns all databases as @databases" do
      db = Database.create! valid_attributes
      get :index
      assert_template 'index'
      assigns(:databases).should include db
    end
  end
  
  def test_show
    get :show, :id => @database
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
### TODO: understand why it fails
### test_create_invalid(DatabasesControllerTest) [test/functional/databases_controller_test.rb:26]:
###   Expected block to return true value.
###
###  def test_create_invalid
###    Database.any_instance.stubs(:valid?).returns(false)
###    post :create
###    assert_response :success
###    assert_template 'new'
###  end

  def test_create_valid
    Database.any_instance.stubs(:valid?).returns(true)
    post :create, :database => { :name => "database", :database_type => "postgres", :server_ids => [] }
    assert_redirected_to databases_url #database_url(assigns(:database))
  end
  
  def test_edit
    get :edit, :id => @database
    assert_template 'edit'
  end
  
### TODO: understand why it fails
### test_create_invalid(DatabasesControllerTest) [test/functional/databases_controller_test.rb:26]:
###   Expected block to return true value.
###
###  def test_update_invalid
###    Database.any_instance.stubs(:valid?).returns(false)
###    put :update, :id => @database
###    assert_template 'edit'
###  end

  def test_update_valid
    Database.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @database
    assert_redirected_to databases_url #database_url(assigns(:database))
  end
  
  def test_destroy
    database = Database.first
    delete :destroy, :id => database
    assert_redirected_to databases_url
    assert !Database.exists?(database.id)
  end
end
