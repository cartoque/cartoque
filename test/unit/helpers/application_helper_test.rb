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

  should "display machine with full details" do
    render :text => display_machine(Factory(:machine))
    assert_select "span.machine-link a", "server-01"
    assert_select "span.machine-details", "4 * 4 cores, 3.2 GHz | 42G | 5 * 13G (SAS)"
  end

  should "display nothing in machine details if no details available" do
    render :text => display_machine(Machine.new(:name => "srv"))
    assert_select "span.machine-details", ""
  end
end
