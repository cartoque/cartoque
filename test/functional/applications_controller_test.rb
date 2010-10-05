require 'test_helper'

class ApplicationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Application.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Application.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Application.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to application_url(assigns(:application))
  end
  
  def test_edit
    get :edit, :id => Application.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Application.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Application.first
    assert_template 'edit'
  end

  def test_update_valid
    Application.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Application.first
    assert_redirected_to application_url(assigns(:application))
  end
  
  def test_destroy
    application = Application.first
    delete :destroy, :id => application
    assert_redirected_to applications_url
    assert !Application.exists?(application.id)
  end
end
