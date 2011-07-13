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
      assert !app.cerbere, "cerbere should be false"
      app.application_instances << ApplicationInstance.new(:name => "prod", :authentication_method => "cerbere")
      assert app.save
      assert_equal 1, app.application_instances.count
      assert app.reload.cerbere, "cerbere should be true"
    end
  end

  context "#sorted_application_instances" do
    should "resist to empty arrays" do
      app = Factory(:application)
      assert_equal [], app.application_instances
      assert_equal [], app.sorted_application_instances
    end

    should "be ordered with prod, ecole, preprod first" do
      app = Factory(:application)
      app.application_instances << ApplicationInstance.new(:name => "ecole", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "aaaa", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "ffff", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "zzzz", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "prod", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "preprod", :authentication_method => "none")
      assert app.save
      app.reload
      assert_equal 6, app.application_instances.count
      assert_equal %w(prod ecole preprod aaaa ffff zzzz), app.sorted_application_instances.map(&:name)
    end
  end
end
