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
    Application.new(name: "fakeapp").should be_valid
  end

  describe "Application.search" do
    before do
      Application.create!(name: "app-01")
      Application.create!(name: "app-02")
    end

    it "should return every application when query is blank or is not a string" do
      Application.count.should_not eq(0)
      Application.search(nil).length.should eq(Application.count)
      Application.search("").length.should eq(Application.count)
    end

    it "shouldn't be case sensitive" do
      Application.search("App-01").length.should eq 1
    end
  end

  describe "Application#sorted_application_instances" do
    it "should resist to empty arrays" do
      app = FactoryGirl.create(:application)
      app.application_instances.should eq []
      app.sorted_application_instances.should eq []
    end

    it "should be ordered with prod, ecole, preprod first" do
      app = FactoryGirl.create(:application)
      ApplicationInstance.create!(name: "ecole", authentication_method: "none", application_id: app.id)
      ApplicationInstance.create!(name: "aaaa", authentication_method: "none", application_id: app.id)
      ApplicationInstance.create!(name: "ffff", authentication_method: "none", application_id: app.id)
      ApplicationInstance.create!(name: "zzzz", authentication_method: "none", application_id: app.id)
      ApplicationInstance.create!(name: "prod", authentication_method: "none", application_id: app.id)
      ApplicationInstance.create!(name: "preprod", authentication_method: "none", application_id: app.id)
      app.should have(6).application_instances
      app.sorted_application_instances.map(&:name).should eq %w(prod ecole preprod aaaa ffff zzzz)
    end
  end

  describe "#dokuwiki_pages" do
    it "should return no doc" do
      app = Application.new(name: "app-03")
      app.dokuwiki_pages.should eq []
    end

    it "should return doc corresponding to */app_name/* or */app_name.txt" do
      app = Application.new(name: "app-01")
      app.dokuwiki_pages.should have(2).docs
      app.dokuwiki_pages.should include("app-01")
      app.dokuwiki_pages.should include("app-01:doc")
    end

    it "should return doc depending on linked application_urls" do
      app = Application.new(name: "application-02")
      app_instance = ApplicationInstance.new(name: "prod")
      app_url = ApplicationUrl.new(url: "http://app-02.example.com/index.php")
      app_instance.application_urls << app_url
      app.application_instances << app_instance
      app.dokuwiki_pages.should eq ["app-02.example.com"]
    end
  end

  describe "#relationships" do
    let!(:app)  { Application.create(name: "Skynet") }
    let!(:role) { Role.create(name: "Developer") }
    let!(:user) { Contact.create(last_name: "Mitnick", first_name: "Kevin") }
    let!(:rel)  { Relationship.create(item: app, role: role, contacts: [user]) }

    it "returns a map of relationships grouped by role" do
      map = app.relationships_map
      map["not-a-key"].should == []
      map[role.id.to_s].should == [ rel ]
    end
  end
end
