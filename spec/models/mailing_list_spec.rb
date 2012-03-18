require 'spec_helper'

describe MailingList do
  pending "update contact ids" do
    ml = MailingList.create(name: "My list")
    contact = Contact.create(last_name: "Doe")
    ml.contact_ids.should == []
    ml.contact_ids = [contact.id]
    ml.save
    ml.contact_ids.should include contact.id
    ml.contacts.should include contact
  end
end
