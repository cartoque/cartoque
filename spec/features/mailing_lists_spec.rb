require 'spec_helper'

describe "Mailing Lists" do
  let(:user) { FactoryGirl.create(:user) }
  before { login_as user }

  let!(:contact) { FactoryGirl.create(:contact) }
  let!(:company) { FactoryGirl.create(:company) }

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
      john = Contact.create!(last_name: "Doe", email_infos: [ { value: "john@doe.com" } ])
      visit new_mailing_list_path
      fill_in "mailing_list_name", with: "Executive committee"
      select "Doe <john@doe.com>", from: "mailing_list_contact_ids"
      click_button "Create"
      current_path.should == mailing_lists_path
      page.should have_content "Executive committee"
      page.should have_content "john@doe.com"
    end
  end

  describe "GET /mailing_lists/:id/edit" do
    it "edits an existing mailing list" do
      john = Contact.create!(last_name: "Doe", email_infos: [ { value: "john@doe.com" } ])
      list = MailingList.create!(name: "Board", contact_ids: [ john.id ])
      visit edit_mailing_list_path(list)
      fill_in "mailing_list_name", with: "The board"
      unselect "Doe <john@doe.com>", from: "mailing_list_contact_ids"
      click_button "Apply modifications"
      current_path.should == mailing_lists_path
      page.should have_content "The board"
      page.should_not have_content "john@doe.com"
    end
  end

  describe "DELETE /mailing_lists/:id" do
    it "destroys the requested list" do
      john = Contact.create!(last_name: "Dupont", email_infos: [ { value: "john@dupont.com" } ])
      list = MailingList.create!(name: "Board", contact_ids: [ john.id ])
      visit mailing_lists_path
      click_link "Delete mailinglist #{list.to_param}"
      current_path.should == mailing_lists_path
      page.should have_content "Mailing list was successfully destroyed"
      page.should_not have_content "Board"
      MailingList.count.should == 0
      Contact.where(last_name: "Dupont").to_a.count.should == 1
    end
  end
end
