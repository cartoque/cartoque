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
end
