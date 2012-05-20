#encoding: utf-8
require 'spec_helper'

describe Contact do
  it "has a first name, a last name and an image url to be valid" do
    Contact.new.should_not be_valid
    Contact.new(last_name: "Doe", image_url: "").should_not be_valid
    Contact.new(last_name: "Doe", image_url: "ceo.png").should be_valid
    Contact.new(last_name: "Doe").image_url.should == "ceo.png"
  end

  it "returns the full name of a person" do
    contact = Contact.new(first_name: "John", last_name: "Doe")
    contact.full_name.should == "John Doe"
  end

  it "returns a shortened version of the name of a person" do
    contact = Contact.new(first_name: "John-Mitchel Charles", last_name: "Doe")
    contact.short_name.should == "JMC Doe"
    contact.first_name = "Jérémy"
    contact.short_name.should == "J Doe"
    contact.first_name = "john"
    contact.last_name = "DOE"
    contact.short_name.should == "J Doe"
  end

  it "shortens long email addresses" do
    c = Contact.create!(last_name: "Doe")
    EmailInfo.create!(value: "john.doe@example.com", entity: c)
    c.reload.short_email.should == "john.doe@example.com"
    c.contact_infos.first.destroy
    EmailInfo.create!(value: "john.doe@very.long-subdomain.example.com", entity: c)
    c.reload.short_email.should == "john.doe@...example.com"
  end

  it "destroys the associated contact infos when deleted" do
    c = Contact.create(first_name: "John", last_name: "Doe")
    c.should be_persisted
    c.should have(0).contact_infos
    EmailInfo.create(value: "blah@example.com", entity: c)
    EmailInfo.create(value: "555-123456", entity: c)
    c.reload.should have(2).contact_infos
  end

  describe "#available_images and #available_images_index" do
    it "is an array of available images" do
      Contact.available_images.should be_a(Array)
    end

    it "generates a hash" do
      hsh = Contact.available_images_hash
      images = Contact.available_images
      hsh.should be_a(Hash)
      hsh.length.should eq images.length
      hsh.keys.sort.should eq images.sort
      hsh.values.sort.should eq images.sort
    end
  end

  describe "#search" do
    before do
      @contact1 = Contact.create(first_name: "John", last_name: "Doe", job_position: "Commercial")
      @contact2 = Contact.create(first_name: "James", last_name: "Dean", job_position: "Director")
    end

    it "returns everything if parameter is blank" do
      Contact.like("").to_a.should =~ [@contact1, @contact2]
    end
    
    it "filters contacts by first_name, last_name, and job_position" do
      Contact.like("James").to_a.should =~ [@contact2]
      Contact.like("Doe").to_a.should =~ [@contact1]
      Contact.like("D").to_a.should =~ [@contact1, @contact2]
      Contact.like("Director").to_a.should =~ [@contact2]
    end
  end

  describe "#emailable" do
    it "returns only people/companies with some email_infos" do
      c1 = Contact.create(last_name: "Doe", email_infos: [ EmailInfo.new(value: "a@b.com") ])
      c2 = Contact.create(last_name: "Grinch")
      Contact.emailable.should == [ c1 ]
    end
  end

  #TODO: move it to a dedicated spec on Contactable module
  describe "#with_internals scope" do
    it "retrieve internal users only if param is truthy" do
      bob = Contact.create!(last_name: "Smith", internal: true)
      alice = Contact.create!(last_name: "Smith", internal: false)
      Contact.all.should include bob
      Contact.all.should include alice
      Contact.with_internals(false).to_a.should_not include bob
      Contact.with_internals(false).to_a.should include alice
      #but
      Contact.with_internals(true).to_a.should include bob
      Contact.with_internals(true).to_a.should include alice
    end
  end

  describe "#company_name=" do
    it "auto-creates a company if none with that name already exists" do
      company = Company.create(name: "World Company")
      lambda { Contact.create(last_name: "Smith", company_name: "World Company") }.should_not change(Company, :count)
      Company.where(name: "Universe Company").count.should eq 0
      lambda { Contact.create(last_name: "Parker", company_name: "Universe Company") }.should change(Company, :count).by(+1)
      Company.where(name: "Universe Company").count.should eq 1
    end

    it "propagates #internal value when auto-creating a company" do
      company = Company.create(name: "World Company")
      Contact.create(last_name: "Smith", company_name: "World Company", internal: true)
      company.reload.internal.should be_false
      Contact.create(last_name: "Parker", company_name: "Universe Company", internal: false)
      Company.where(name: "Universe Company").first.internal.should be_false
      #but
      #WARNING: it only works if internal field is set before company_name, which is the case in the HTML form
      #TODO: fix it :)
      Contact.create(last_name: "Goldberg", internal: true, company_name: "Our team")
      Company.where(name: "Our team").first.internal.should be_true
    end
  end
end
