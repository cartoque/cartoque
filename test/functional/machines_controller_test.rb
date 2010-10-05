require 'test_helper'

class MachinesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Machine.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Machine.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Machine.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to machine_url(assigns(:machine))
  end
  
  def test_edit
    get :edit, :id => Machine.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Machine.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Machine.first
    assert_template 'edit'
  end

  def test_update_valid
    Machine.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Machine.first
    assert_redirected_to machine_url(assigns(:machine))
  end
  
  def test_destroy
    machine = Machine.first
    delete :destroy, :id => machine
    assert_redirected_to machines_url
    assert !Machine.exists?(machine.id)
  end
end
