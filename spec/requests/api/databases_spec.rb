require 'spec_helper'

describe "Databases API" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:database) { Database.create!(name: "db-01", type: "postgres") }
  let!(:instance1) { DatabaseInstance.create!(name: "pg-cluster-01", database: database, databases: {"foo"=>123}) }
  let!(:instance2) { DatabaseInstance.create!(name: "pg-cluster-empty", database: database) }

  describe "GET /databases.json" do
    it "gets all databases" do
      get databases_path(format: "json").to_s, {}, "HTTP_X_API_TOKEN" => user.authentication_token
      response.status.should == 200
      res = JSON.parse(response.body) rescue nil
      res.should_not be nil
      res.keys.should == ["databases"]
      res["databases"].should have(1).database
      db = res["databases"].first
      db["name"].should == "db-01"
      db["instances"].count.should == 1
      db["instances"].first["name"].should == "pg-cluster-01"
    end
  end

  describe "GET /databases/:id" do
    it "shows a specific database" do
      get database_path(id: database.id.to_s, format: "json").to_s,
          {}, "HTTP_X_API_TOKEN" => user.authentication_token
      response.status.should == 200
      res = JSON.parse(response.body) rescue nil
      res.should_not be nil
      res.keys.should == ["database"]
      db = res["database"]
      db["name"].should == "db-01"
    end
  end
end
