require 'test_helper'

class DatabasesHelperTest < ActionView::TestCase
  setup do
    @database = Factory(:database)
  end

  should "display nodes under a database" do
    assert @database.machines.present?
    assert_equal "database-01", @database.name
    assert_equal "server-01", @database.machines.map(&:name).join(" ")
    render :text => database_nodes(@database)
    assert_select 'strong', @database.name
    assert_select 'ul' do
      assert_select 'li', @database.machines.first.name
    end
  end

  should "display pretty size" do
    assert_equal "<abbr title=\"1.0Mo\">0.0</abbr>", display_size(1024**2)
    assert_equal "2.5", display_size(2.5*1024**3)
  end

  context "#databases_summary" do
    should "return empty string if databases list is empty" do
      assert_equal "", databases_summary([])
    end

    should "return databases where size >= total_size / 6" do
      databases = {"big_one" => 19, "little_one" => 2, "big_two" => 15, "little_two" => 3}
      assert databases_summary(databases).match(/^big_one, big_two/)
      assert ! databases_summary(databases).include?("little")
    end

    should "return first two databases if none is greater than total_size / 6" do
      databases = {"big_one" => 2, "big_two" => 2}
      (1..8).each { |i| databases[i.to_s] = 1 }
      assert databases_summary(databases).match(/^big_one, big_two/)
      assert ! databases_summary(databases).include?("little")
    end
  end
end
