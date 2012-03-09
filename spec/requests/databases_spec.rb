require 'spec_helper'

describe "Databases" do
  let(:user) { FactoryGirl.create(:user) }
  before { login_as user }

  let!(:database) { Database.create!(name: "db-01", database_type: "postgres") }

  describe "GET /databases" do
    it "gets all databases" do
      visit databases_path
      page.status_code.should be 200
      page.should have_content "db-01"
    end
  end

  describe "GET /databases/:id" do
    it "shows a database page" do
      visit database_path(database.to_param)
      page.should have_selector "h1", text: "Database DB-01"
    end
  end

  describe "GET /databases/new" do
    it "creates a new database" do
      visit new_database_path
    end
  end

  describe "GET /databases/:id/edit" do
    it "edits a database" do
      visit edit_database_path(database.to_param)
    end
  end

  describe "GET /databases/distribution" do
    it "shows a map of your databases" do
      visit distribution_databases_path
    end
  end
end
