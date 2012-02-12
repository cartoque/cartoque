require "spec_helper"

describe ComponentsController do
  describe "routing" do

    it "routes to #index" do
      get("/components").should route_to("components#index")
    end

    it "routes to #new" do
      get("/components/new").should route_to("components#new")
    end

    it "routes to #show" do
      get("/components/1").should route_to("components#show", :id => "1")
    end

    it "routes to #edit" do
      get("/components/1/edit").should route_to("components#edit", :id => "1")
    end

    it "routes to #create" do
      post("/components").should route_to("components#create")
    end

    it "routes to #update" do
      put("/components/1").should route_to("components#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/components/1").should route_to("components#destroy", :id => "1")
    end

  end
end
