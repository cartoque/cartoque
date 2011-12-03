#encoding: utf-8
require 'spec_helper'

describe Contact do
  it "should have a first name, a last name and an image url to be valid" do
    Contact.new.should_not be_valid
    Contact.new(:last_name => "Doe", :image_url => "").should_not be_valid
    Contact.new(:last_name => "Doe", :image_url => "ceo.png").should be_valid
  end

  it "should return the full name of a person" do
    contact = Contact.new(:first_name => "John", :last_name => "Doe")
    contact.full_name.should == "John Doe"
  end

  it "should return a shortened version of the name of a person" do
    contact = Contact.new(:first_name => "John-Mitchel Charles", :last_name => "Doe")
    contact.short_name.should == "JMC Doe"
    contact.first_name = "Jérémy"
    contact.short_name.should == "J Doe"
    contact.first_name = "john"
    contact.last_name = "DOE"
    contact.short_name.should == "J Doe"
  end

  it "should shorten long email addresses" do
    c = Contact.new
    c.email_infos = [ContactInfo.new(:value => "john.doe@example.com", :info_type => "mail")]
    c.short_email.should == "john.doe@example.com"
    c.email_infos = [ContactInfo.new(:value => "john.doe@very.long-subdomain.example.com", :info_type => "mail")]
    c.short_email.should == "john.doe@...example.com"
  end

  it "should destroy the associated contact infos when deleted" do
    c = Contact.create(:first_name => "John", :last_name => "Doe")
    c.should be_persisted
    lambda {
      c.email_infos << ContactInfo.new(:value => "blah@example.com", :info_type => "email")
      c.phone_infos << ContactInfo.new(:value => "555-123456", :info_type => "phone")
      c.save
    }.should change(ContactInfo, :count).by(+2)
    c.reload.should have(2).contact_infos
    lambda {
      c.destroy
    }.should change(ContactInfo, :count).by(-2)
  end

  describe "#available_images and #available_images_index" do
    it "should be an array of available images" do
      Contact.available_images.should be_a(Array)
    end

    pending "should generate a hash"
  end

  describe "#search" do
    before do
      @contact1 = Contact.create(:first_name => "John", :last_name => "Doe", :job_position => "Commercial")
      @contact2 = Contact.create(:first_name => "James", :last_name => "Dean", :job_position => "Director")
    end

    it "should return everything if parameter is blank" do
      Contact.search("").should eq [@contact1, @contact2]
    end
    
    it "should filter contacts by first_name, last_name, and job_position" do
      Contact.search("James").should eq [@contact2]
      Contact.search("Doe").should eq [@contact1]
      Contact.search("D").should eq [@contact1, @contact2]
      Contact.search("Director").should eq [@contact2]
    end
  end
end
