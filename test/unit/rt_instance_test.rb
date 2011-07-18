require 'test_helper'
require 'rt_instance'

class RTInstance
  def self.dir
    Rails.root.join("test/data/rt").to_s
  end
end

class RTInstanceTest < ActiveSupport::TestCase
  context "RedmineInstance.all" do
    should "return fake directory" do
      assert RTInstance.dir.include?("test/data/rt")
    end

    should "return all rt instances" do
      instances = RTInstance.all
      assert_equal 2, instances.size
      instance = instances.detect{|i| i.name == "rt_client_01"}
      assert instance.is_a?(RTInstance)
      assert_equal "rt-01", instance.server
      assert_equal 261, instance.nb_users
      assert_equal "", instance.no_method
    end
  end
end
