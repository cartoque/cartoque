# encoding: utf-8
require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  should "display action links" do
    render :text => action_links { "blah" }
    assert_select "div.actions", "blah" 
  end 

  should "render some links to external applications" do
    render :text => links_for(Factory(:application))
    redmine = "http://redmine.test.host/projects/appli-01"
    assert_select "a.link-to-redmine[href=#{redmine}]", "R"
  end

  should "display server with full details" do
    render :text => display_server(Factory(:server))
    assert_select "span.server-link a", "server-01"
    assert_select "span.server-details", "4 * 4 cores, 3.2 GHz | 42G | 5 * 13G (SAS)"
  end

  should "display server without raising an exception if no details" do
    render :text => display_server(Server.create(:name => "server-03"))
    assert_select "span.server-link a", "server-03"
  end

  should "display nothing in server details if no details available" do
    render :text => display_server(Server.new(:name => "srv"))
    assert_select "span.server-details", ""
  end

  context "#context_li" do
    should "display a li.current if item is the current one" do
      render :text => context_li("blah", "url", :current => true)
      assert_select "li.current", "blah"
      assert select "li a", false, "shouldn't contain a link"
    end

    should "display normal li with link inside otherwise" do
      render :text => context_li("blah", "url", :current => false)
      assert_select "li > a[href=url]", "blah"
      assert_select "li.current", false, "shouldn't be the current li"
    end
  end

  context "#link_to_server_if_exists" do
    should "return server name if no server found" do
      link = link_to_server_if_exists("blah")
      assert link.include?("blah")
      render :text => link
      assert_select "a", "+"
    end

    should "return a link to the server if a server with that name exists" do
      render :text => link_to_server_if_exists(Factory(:server).name)
      assert_select "a", "server-01"
    end
  end

  context "#link_to_servername" do
    should "return a link to /servers/<server identifier>" do
      render :text => link_to_servername(Factory(:server).name)
      assert_select "a[href=/servers/server-01]"
    end
  end
end
