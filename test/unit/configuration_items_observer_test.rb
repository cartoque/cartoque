require 'test_helper'

class ConfigurationItemsObserverTest < ActiveSupport::TestCase
  should "create a CI when a concrete-CI-object is saved" do
    s = Server.new(:name => "my-new-server")
    assert s.configuration_item.blank?
    assert_difference "ConfigurationItem.count", +1 do
      s.save
    end
    assert s.persisted?
    assert s.reload.configuration_item.present?
  end

  should "update its CI when a concrete-CI-object with an existing CI is updated" do
    s = Server.create(:name => "my-new-server")
    assert_not_nil s.reload.configuration_item
    assert_equal "server::my-new-server", s.configuration_item.identifier
    s.name = "new-name"
    assert_no_difference "ConfigurationItem.count" do
      s.save!
    end
    assert_equal "server::new-name", s.reload.configuration_item.identifier
  end

  should "destroy its CI if real-CI-object is destroyed" do
    s = Server.create(:name => "my-new-server")
    assert_not_nil s.reload.configuration_item
    assert_difference "ConfigurationItem.count", -1 do
      s.destroy
    end
  end

  should "not bother if a model isn't a concrete-CI-object" do
    s = Setting.new(:key => "dummy")
    assert_no_difference "ConfigurationItem.count" do
      s.save!
    end
  end

  should "not generate the CI twice, in any case" do
    s = Server.new(:name => "my-new-server")
    assert_difference "ConfigurationItem.count", +1 do
      s.save!
    end
    assert_no_difference "ConfigurationItem.count" do
      s.save!
    end
  end
end
