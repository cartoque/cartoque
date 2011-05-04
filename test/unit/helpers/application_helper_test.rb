require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  should "display action links" do
    render :text => action_links { "blah" }
    assert_select "p.actions", "blah" 
  end 
end
