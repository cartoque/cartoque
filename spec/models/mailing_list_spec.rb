require 'spec_helper'

describe MailingList do
  let(:ml) { MailingList.create(name: "My list") }
  let(:contact) { Contact.create(last_name: "Doe", email_infos: [ EmailInfo.new(value: "john@doe.com") ]) }
  let (:company) { Company.create(name: "World Company", email_infos: [ EmailInfo.new(value: "world@company.com") ]) }

  it "updates contact and company ids" do
    ml.contact_ids.should == []
    ml.company_ids.should == []
    ml.update_attributes(contact_ids: [contact.id.to_s], company_ids: [company.id.to_s])
    ml.reload
    ml.contact_ids.should include contact.id
    ml.contacts.should include contact
    ml.company_ids.should include company.id
    ml.companies.should include company
  end

  it "groups contactable objects" do
    ml.contactables.should == []
    ml.update_attributes(contact_ids: [contact.id.to_s], company_ids: [company.id.to_s])
    ml.reload
    ml.contactables.should =~ [contact, company]
  end

  it "gives access to mail addresses directly" do
    ml.update_attributes(contact_ids: [contact.id.to_s], company_ids: [company.id.to_s])
    ml.reload
    ml.email_addresses.should =~ %w(john@doe.com world@company.com)
  end

  describe "#email_addresses" do
    it "should fail silently if an user no more has email address" do
      ml.update_attributes(contact_ids: [contact.id.to_s], company_ids: [company.id.to_s])
      contact.email_infos.first.destroy
      ml.reload
      ml.email_addresses.should == %w(world@company.com)
    end
  end
end
