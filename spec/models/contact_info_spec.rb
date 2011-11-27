require 'spec_helper'

describe ContactInfo do
  it "should have all fields to be valid" do
    info = ContactInfo.new
    info.should_not be_valid
    info.should have_at_least(3).errors
    info.contact_id = Factory(:contact).id
    info.info_type = "phone"
    info.value = "555-123456"
    info.should be_valid
  end

  it "should be destroyed when destroying the contact" do
    contact = Factory(:contact)
    contact.contact_infos << ContactInfo.new(:info_type => "phone", :value => "555-123456")
    contact.save!
    contact.should have(1).contact_info
    lambda { contact.destroy }.should change(ContactInfo, :count).by(-1)
  end

  it "should display value when using #to_s" do
    ContactInfo.new(:value => "blah").to_s.should eq "blah"
  end
end
