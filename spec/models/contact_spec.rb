require 'spec_helper'

describe Contact do
  it "should have a first and a last name to be valid" do
    Contact.new.should_not be_valid
    Contact.new(:first_name => "John", :last_name => "Doe").should be_valid
  end

  it "should return the full name of a person" do
    contact = Contact.new(:first_name => "John", :last_name => "Doe")
    contact.full_name.should == "John Doe"
  end

  it "should return the full job position of a person" do
    person = Factory(:contact)
    person.full_position.should eq "CEO, WorldCompany"
    person.company = nil
    person.full_position.should eq "CEO"
    person.company = Company.new(:name => "Blah Inc.")
    person.job_position = ""
    person.full_position.should eq "Blah Inc."
  end

  it "should shorten long email addresses" do
    c = Contact.new
    c.email_infos = [ContactInfo.new(:value => "john.doe@example.com", :info_type => "mail")]
    c.short_email.should == "john.doe@example.com"
    c.email_infos = [ContactInfo.new(:value => "john.doe@very.long-subdomain.example.com", :info_type => "mail")]
    c.short_email.should == "john.doe@...example.com"
  end
end
