# encoding: utf-8
require 'spec_helper'

describe ApplicationHelper do
  it "should display action links" do
    render :text => action_links { "blah" }
    assert_select "div.actions", "blah" 
  end 

  describe "#links_for" do
    before do
      Settler.load!
    end

    it "should render some links to external applications" do
      render :text => links_for(Factory(:application))
      redmine = "http://redmine.test.host/projects/appli-01"
      assert_select "a.link-to-redmine[href=#{redmine}]", "R"
    end

    it "should accept custom value for redmine_url" do
      Settler.redmine_url.update_attribute(:value, "http://redmine.org")
      render :text => links_for(Factory(:application))
      assert_select "a.link-to-redmine[href=http://redmine.org/projects/appli-01]", "R"
    end

    it "should not fail if redmine_url is blank (default value in this case)" do
      Settler.redmine_url = ""
      render :text => links_for(Factory(:application))
      redmine = "http://redmine.test.host/projects/appli-01"
      assert_select "a.link-to-redmine[href=#{redmine}]", "R"
    end
  end

  describe "#context_li" do
    it "should display a li.current if item is the current one" do
      render :text => context_li("blah", "url", :current => true)
      assert_select "li.current", "blah"
      assert select "li a", false, "shouldn't contain a link"
    end

    it "should display normal li with link inside otherwise" do
      render :text => context_li("blah", "url", :current => false)
      assert_select "li > a[href=url]", "blah"
      assert_select "li.current", false, "shouldn't be the current li"
    end
  end

  describe "#link_to_server_if_exists" do
    it "should return server name if no server found" do
      link = link_to_server_if_exists("blah")
      assert link.include?("blah")
      render :text => link
      assert_select "a", "+"
    end

    it "should return a link to the server if a server with that name exists" do
      render :text => link_to_server_if_exists(Factory(:server).name)
      assert_select "a", "server-01"
    end
  end

  describe "#link_to_servername" do
    it "should return a link to /servers/<server identifier>" do
      render :text => link_to_servername(Factory(:server).name)
      assert_select "a[href=/servers/server-01]"
    end
  end

  describe "#link_to_website" do
    it "should generate a link to a website" do
      website = "http://www.example.com"
      link_to_website(website).should eq %(<a href="#{website}">#{website}</a>)
    end

    it "should add 'http://' if no protocol defined" do
      website = "www.example.com"
      link_to_website(website).should eq %(<a href="http://#{website}">#{website}</a>)
    end
  end
end
