require 'spec_helper'

describe "Mailing Lists" do
  let(:user) { FactoryGirl.create(:user) }
  before { login_as user }

  let!(:contact) { Factory.create(:contact) }
  let!(:company) { Factory.create(:company) }

  describe "GET /mailing_lists" do
    it "gets all mailing lists" do
      MailingList.create!(name: "My List")
      visit mailing_lists_path
      page.status_code.should be 200
      page.should have_content "My List"
    end
  end

  describe "GET /mailing_lists/new" do
    it "adds a new mailing list" do
      visit new_mailing_list_path
    end
  end
end
