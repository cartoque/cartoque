require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = Factory(:user)
  end

  context "#settings" do
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

  context "#set_setting" do
    should "set a setting (without saving the user)" do
      assert @user.settings.blank?
      @user.set_setting(:a, "b")
      @user.save
      assert_equal "b", @user.reload.settings[:a]
    end
  end

  context "#update_setting" do
    should "set a setting and save the user" do
      assert @user.settings.blank?
      @user.update_setting(:a, "b")
      assert_equal "b", @user.reload.settings[:a]
    end
  end
end
