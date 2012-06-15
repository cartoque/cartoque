require 'spec_helper'

describe TomcatsController do
  login_user

  it "gets index" do
    get :index
    assert_response :success
  end

  describe "/index.csv" do
    render_views

    it "returns tomcats in csv style" do
      Tomcat.create!(name: "TC60_01", dns: "app01.example.com", java_version: "Java160",
                     server: Server.create!(name: "vm-01"))
      get :index, format: "csv"
      assert_response :success
      response.body.should include("vm-01,TC60_01,app01.example.com,Java160")
      response.body.lines.count.should == 1
    end
  end
end
