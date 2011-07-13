require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  should "be valid" do
    assert ! Application.new.valid?
    assert Application.new(:name => "fakeapp").valid?
  end

  context "Application.like" do
    setup do
      Application.create!(:name => "app-01")
      Application.create!(:name => "app-02")
    end

    should "return every application when query is blank or is not a string" do
      assert_not_equal 0, Application.count
      assert_equal Application.count, Application.search(nil).length
      assert_equal Application.count, Application.search("").length
    end
  end

  context "#application_instances" do
    should "update #cerbere from #application_instances when saved" do
      app = Factory(:application)
      assert_equal 0, app.application_instances.size
      assert app.cerbere
      ApplicationInstance.create!(:name => "prod", :application_id => app.id, :authentication_method => "cerbere")
      app.reload
      assert !app.cerbere
    end
  end
end
