require 'spec_helper'

describe MailingList do
  it "updates contact ids" do
    ml = MailingList.create(name: "My list")
    contact = Contact.create(last_name: "Doe")
    ml.contact_ids.should == []
    ml.contact_ids = [contact.id.to_s]
    ml.save
    ml.reload
    ml.contact_ids.should include contact.id
    ml.contacts.should include contact
  end
end
