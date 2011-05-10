require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  should "display action links" do
    render :text => action_links { "blah" }
    assert_select "p.actions", "blah" 
  end 

  should "render some links to external applications" do
    render :text => links_for(Factory(:application))
    redmine = "http://redmine.test.host/projects/appli-01"
    assert_select "a.link-to-redmine[href=#{redmine}]", "R"
  end
end
