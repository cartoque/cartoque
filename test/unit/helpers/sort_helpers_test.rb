require 'test_helper'

class FakeController
  attr_accessor :params

  include SortHelpers

  def resource_class
    Server
  end

  def sort_column_prefix
    "prefix."
  end

  def direction; sort_direction; end
  def column; sort_column; end
  def option; sort_option; end
end

class SortHelpersTest < ActionView::TestCase
  setup do
    @controller = FakeController.new
  end

  test "sort_direction should default to 'name'" do
    @controller.params = {}
    assert_equal "name", @controller.column
  end

  test "sort_option should only accept attributes among model column_names" do
    @controller.params = {:sort => "manufacturer"}
    assert_equal "manufacturer", @controller.column
    @controller.params = {:sort => "namez"}
    assert_equal "name", @controller.column
    @controller.params = {:sort => ["test"]}
    assert_equal "name", @controller.column
  end

  test "sort_option should accept coma separated values" do
    @controller.params = {:sort => "name,manufacturer"}
    assert_equal "name,manufacturer", @controller.column
    @controller.params = {:sort => "name,manufacturer,not_a_column"}
    assert_equal "name,manufacturer", @controller.column
  end

  test "sort_direction should default to 'asc'" do
    @controller.params = {}
    assert_equal "asc", @controller.direction
  end

  test "sort_direction should only accept values among asc/desc" do
    @controller.params = {:direction => "desc"}
    assert_equal "desc", @controller.direction
    @controller.params = {:direction => "asc"}
    assert_equal "asc", @controller.direction
    @controller.params = {:direction => "blah"}
    assert_equal "asc", @controller.direction
    @controller.params = {:direction => ["test","blah"]}
    assert_equal "asc", @controller.direction
  end

  test "sort_option should be a correct mix between sort_column and sort_direction" do
    @controller.params = {}
    assert_equal "prefix.name asc", @controller.option
    @controller.params = {:sort => "name,manufacturer", :direction => "desc"}
    assert_equal "prefix.name desc, prefix.manufacturer desc", @controller.option
  end
end
