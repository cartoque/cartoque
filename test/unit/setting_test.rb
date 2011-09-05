require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  context "#safe_cas_server" do
    setup do
      Settler.load!
      @setting = Setting.find_or_create_by_key(:key => "cas_server")
      #don't hardcode this because Psyck is buggy in mri p180, yaml anchors are not merged correctly
      @default_value = Settler.config["cas_server"]["value"]
    end

    should "return the #cas_server if set" do
      assert @setting.update_attribute(:value, "http://cas.example.com")
      assert_equal "http://cas.example.com", Settler.safe_cas_server
    end

    should "return the default value if #cas_server is blank or nearly blanked" do
      assert @setting.update_attribute(:value, " ")
      assert_equal @default_value, Settler.safe_cas_server
    end

    should "return the default value if #cas_server is missing" do
      @setting.delete
      assert_blank Settler.cas_server
      assert_equal @default_value, Settler.safe_cas_server
    end
  end
end
