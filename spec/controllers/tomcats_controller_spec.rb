require 'spec_helper'

#let's change Tomcat.dir
#TODO: a bit ugly, make it better!
require 'tomcat'
class Tomcat
  def self.dir
    File.expand_path("spec/data/tomcat", Rails.root)
  end
end

describe TomcatsController do
  login_user

  it "should get index" do
    get :index
    assert_response :success
  end

  describe "/index.csv" do
    render_views
    it "should return tomcats in csv style" do
      get :index, format: "csv"
      assert_response :success
      response.body.should include("vm-01,TC60_01,app01.example.com,Java160")
      response.body.lines.count.should == 4
    end
  end
end
