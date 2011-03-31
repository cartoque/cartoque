require 'test_helper'

class DatabasesHelperTest < ActionView::TestCase
  setup do
    @database = Factory(:database)
  end

  should "display nodes under a database" do
    assert @database.machines.present?
    assert_equal "database-01", @database.name
    assert_equal "server-01", @database.machines.map(&:nom).join(" ")
    render :text => database_nodes(@database)
    assert_select 'strong', @database.name
    assert_select 'ul' do
      assert_select 'li', @database.machines.first.nom
    end
  end

  should "display pretty size" do
    assert_equal "<abbr title=\"1.0Mo\">0.0</abbr>", display_size(1024**2)
    assert_equal "2.5", display_size(2.5*1024**3)
  end
end
