require 'spec_helper'

describe DatabasesController do
  login_user
  
  # This should return the minimal set of attributes required to create a valid
  # Database. As you add validations to Database, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {name: "db-01", type: "postgres"}
  end

  before do
    @database = FactoryGirl.create(:database)
  end

  describe "GET :index" do
    it "assigns all databases as @databases" do
      db = Database.create! valid_attributes
      get :index
      assert_template 'index'
      assigns(:databases).should include db
    end
  end
  
  describe "GET :show" do
    it "uses the right template" do
      get :show, id: @database
      assert_template 'show'
    end
  end
  
  describe "GET :new" do
    it "uses the right template" do
      get :new
      assert_template 'new'
    end
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

  describe "POST :create" do
    it "works with valid data" do
      Database.any_instance.stub(:valid?).and_return(true)
      post :create, database: { name: "database", type: "postgres", server_ids: [] }
      assert_redirected_to databases_url #database_url(assigns(:database))
    end
  end

  describe "GET :edit" do
    it "uses the right template" do
      get :edit, id: @database
      assert_template 'edit'
    end
  end
  
### TODO: understand why it fails
### test_create_invalid(DatabasesControllerTest) [test/functional/databases_controller_test.rb:26]:
###   Expected block to return true value.
###
###  def test_update_invalid
###    Database.any_instance.stubs(:valid?).returns(false)
###    put :update, id: @database
###    assert_template 'edit'
###  end

  describe "PUT :update" do
    it "works with valid data" do
      Database.any_instance.stub(:valid?).and_return(true)
      put :update, id: @database
      assert_redirected_to databases_url #database_url(assigns(:database))
    end
  end

  describe "DELETE :destroy" do
    it "destroys database" do
      database = Database.first
      delete :destroy, id: database
      assert_redirected_to databases_url
      Database.where(_id: database.id).count.should == 0
    end
  end

  describe "DELETE :destroy_instance" do
    it "destroys a specific database instance" do
      instance = DatabaseInstance.create!(database: @database, name: "Instance", databases: {schema1: "blah"})
      @database.reload.database_instances.count.should == 1
      delete :destroy_instance, id: @database.id, instance_id: instance.id
      assert_redirected_to databases_url
      @database.reload.database_instances.count.should == 0
    end
  end
end
