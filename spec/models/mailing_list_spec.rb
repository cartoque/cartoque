require 'spec_helper'

describe MailingList do
  it "updates contact and company ids" do
    ml = MailingList.create(name: "My list")
    contact = Contact.create(last_name: "Doe")
    company = Company.create(name: "World Company")
    ml.contact_ids.should == []
    ml.company_ids.should == []
    ml.contact_ids = [contact.id.to_s]
    ml.company_ids = [company.id.to_s]
    ml.save
    ml.reload
    ml.contact_ids.should include contact.id
    ml.contacts.should include contact
    ml.company_ids.should include company.id
    ml.companies.should include company
  end
end
