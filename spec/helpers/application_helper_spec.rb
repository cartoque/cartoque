# encoding: utf-8
require 'spec_helper'

describe ApplicationHelper do
  it "displays action links" do
    render text: action_links { "blah" }
    assert_select "div.actions", "blah" 
  end 

  describe "#links_for" do
    it "renders some links to external applications" do
      Setting.redmine_url = "http://redmine.org"
      text = links_for(FactoryGirl.create(:application))
      text.should have_selector "a", class: "link-to-redmine", href: "http://redmine.org/projects/appli-01", content: "R"
    end
  end

  describe "#context_li" do
    it "displays a li>span.current if item is the current one" do
      render text: context_li("blah", "url", current: true)
      assert_select "li span.current", "blah"
      assert select "li a", false, "shouldn't contain a link"
    end

    it "displays normal li with link inside otherwise" do
      render text: context_li("blah", "url", current: false)
      assert_select "li > a[href=url]", "blah"
      assert_select "li span.current", false, "shouldn't be the current li"
    end
  end

  describe "#link_to_server_if_exists" do
    it "returns server name if no server found" do
      link = link_to_server_if_exists("blah")
      assert link.include?("blah")
      render text: link
      assert_select "a", "+"
    end

    it "returns a link to the server if a server with that name exists" do
      render text: link_to_server_if_exists(FactoryGirl.create(:server).name)
      assert_select "a", "server-01"
    end
  end

  describe "#link_to_servername" do
    it "returns a link to /servers/<server identifier>" do
      render text: link_to_servername(FactoryGirl.create(:server).name)
      assert_select "a[href=/servers/server-01]"
    end
  end

  describe "#link_to_website" do
    it "generates a link to a website" do
      website = "http://www.example.com"
      link_to_website(website).should eq %(<a href="#{website}">#{website}</a>)
    end

    it "adds 'http://' if no protocol defined" do
      website = "www.example.com"
      link_to_website(website).should eq %(<a href="http://#{website}">#{website}</a>)
    end
  end

  describe "#sidebar_item" do
    it "displays a link by default" do
      sidebar_item("title", "url").should == %(<li><a href="url">title</a></li>)
    end

    it "optionnally includes a contextual tip" do
      sidebar_item("title", "url", 5).should include %(<div class="contextual">5</div>)
    end
  end
end
