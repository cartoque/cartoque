require 'spec_helper'

describe "General API" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:server) { Server.create!(name: "srv-01") }

  it "forces format to json if api token + no format specified" do
    get servers_path.to_s, {}, "HTTP_X_API_TOKEN" => user.authentication_token
    response.status.should == 200
    response.content_type.should == "application/json"
    res = JSON.parse(response.body) rescue nil
    res.should_not be nil
  end
end
