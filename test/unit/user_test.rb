require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "#settings" do
    setup do
      @user = Factory(:user)
    end

    should "always be a hash" do
      @user.update_attribute(:settings, nil)
      assert_equal Hash.new, @user.reload.settings
    end

    should "serialize settings" do
      hsh = { :a => "b" }
      @user.settings = hsh
      @user.save
      assert_equal hsh, @user.reload.settings
    end
  end
end
