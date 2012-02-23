require 'spec_helper'

describe "Welcome" do

  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as user
  end

  it "includes a welcome message" do
    get root_path
    response.body.should include "Welcome to Cartoque"
  end

  it "includes stats about applications" do
    Application.create!(name: "app-01")
    Application.create!(name: "app-02")
    get root_path
    response.body.should include "2 applications"
  end
end
