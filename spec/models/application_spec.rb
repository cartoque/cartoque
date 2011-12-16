require 'spec_helper'
require 'application'

class Application
  def self.dokuwiki_dir
    File.expand_path("spec/data/dokuwiki", Rails.root)
  end
end

describe Application do
  it "should have a name" do
    Application.new.should_not be_valid
    Application.new(:name => "fakeapp").should be_valid
  end

  describe "Application.like" do
    before do
      Application.create!(:name => "app-01")
      Application.create!(:name => "app-02")
    end

    it "should return every application when query is blank or is not a string" do
      Application.count.should_not eq(0)
      Application.search(nil).length.should eq(Application.count)
      Application.search("").length.should eq(Application.count)
    end
  end

  describe "Application#application_instances" do
    it "should update #cerbere from #application_instances when saved" do
      app = Factory(:application)
      app.application_instances.size.should eq(0)
      app.cerbere.should be_false
      app.application_instances << ApplicationInstance.new(:name => "prod", :authentication_method => "cerbere")
      app.save.should be
      app.should have(1).application_instance
      app.reload.cerbere.should be_true
    end
  end

  describe "Application#sorted_application_instances" do
    it "should resist to empty arrays" do
      app = Factory(:application)
      app.application_instances.should eq []
      app.sorted_application_instances.should eq []
    end

    it "should be ordered with prod, ecole, preprod first" do
      app = Factory(:application)
      app.application_instances << ApplicationInstance.new(:name => "ecole", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "aaaa", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "ffff", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "zzzz", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "prod", :authentication_method => "none")
      app.application_instances << ApplicationInstance.new(:name => "preprod", :authentication_method => "none")
      app.save.should be_true
      app.reload
      app.should have(6).application_instances
      app.sorted_application_instances.map(&:name).should eq %w(prod ecole preprod aaaa ffff zzzz)
    end
  end

  describe "#dokuwiki_pages" do
    it "should return no doc" do
      app = Application.new(:name => "app-03")
      app.dokuwiki_pages.should eq []
    end

    it "should return doc corresponding to */app_name/* or */app_name.txt" do
      app = Application.new(:name => "app-01")
      app.dokuwiki_pages.should have(2).docs
      app.dokuwiki_pages.should include("app-01")
      app.dokuwiki_pages.should include("app-01:doc")
    end

    it "should return doc depending on linked application_urls" do
      app = Application.new(:name => "application-02")
      app_instance = ApplicationInstance.new(:name => "prod")
      app_url = ApplicationUrl.new(:url => "http://app-02.example.com/index.php")
      app_instance.application_urls << app_url
      app.application_instances << app_instance
      app.dokuwiki_pages.should eq ["app-02.example.com"]
    end
  end
end
