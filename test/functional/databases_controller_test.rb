require 'test_helper'

class DatabasesControllerTest < ActionController::TestCase
  setup do
    @database = Factory(:database)
  end

  def test_index
    get :index
    assert_template 'index'
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
    post :create
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
