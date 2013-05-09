require 'spec_helper'

describe "Databases" do
  let(:user) { FactoryGirl.create(:user) }
  before { login_as user }

  let!(:database) { Database.create!(name: "db-01", type: "postgres") }

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
      page.should have_selector "h1", text: /Databases.*db-01/
    end
  end

  describe "GET /databases/new & POST /databases" do
    before do
      FactoryGirl.create(:server)
    end

    it "creates a new database" do
      visit new_database_path
      page.status_code.should == 200
      fill_in "database_name", with: "vm-oracle-01"
      select "oracle", from:  "database_type"
      select "", from: "database_server_ids"
      select "server-01", from: "database_server_ids"
      click_button "Create"
      current_path.should == databases_path
      page.should have_content "vm-oracle-01"
      page.should have_content "server-01"
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
