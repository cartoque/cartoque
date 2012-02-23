require 'spec_helper'

describe "Components" do
  describe "GET /components" do
    before do
      get "/", {}, "HTTP_X_API_TOKEN" => Factory(:user).authentication_token
    end

    it "list all components" do
      get components_path
      response.status.should be(200)
    end
  end
end
