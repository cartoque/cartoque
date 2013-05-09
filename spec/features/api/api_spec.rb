require 'spec_helper'

describe "General API" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:server) { Server.create!(name: "srv-01") }

  before { page.set_headers("HTTP_X_API_TOKEN" => user.authentication_token) }
  after { page.set_headers("HTTP_X_API_TOKEN" => nil) }

  it "forces format to json if api token + no format specified" do
    visit servers_path
    page.status_code.should == 200
    page.response_headers['Content-Type'].should match %r(^application/json)
    res = JSON.parse(page.body) rescue nil
    res.should_not be nil
  end
end
