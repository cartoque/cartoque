require 'test_helper'
require 'redmine_instance'

class RedmineInstance
  def self.dir
    Rails.root.join("test/data/redmine").to_s
  end
end

class RedmineInstanceTest < ActiveSupport::TestCase
  setup do
  end

  should "initialize correctly from hash" do
  end

  context "RedmineInstance.all" do
    should "return fake directory" do
      assert RedmineInstance.dir.include?("test/data/redmine")
    end

    should "return content of files" do
      files = RedmineInstance.files
      assert_equal 1, files.size
      assert files.first.is_a?(String)
    end

    should "return all redmine instances" do
      instances = RedmineInstance.all
      assert_equal 3, instances.size
      instance = instances.detect{|i| i.name == "redmine-01"}
      assert instance.is_a?(RedmineInstance)
      assert_equal "server-01", instance.server
      assert_equal "1.2.0.stable", instance.version
      assert_equal 91247869, instance.size
      assert instance.plugins.is_a?(Array)
    end
  end
end
