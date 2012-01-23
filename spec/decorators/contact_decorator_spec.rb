require 'spec_helper'

describe ContactDecorator do
  before do
    @contact = Factory(:contact).decorate
  end

  it "gives a short form with just last name and first name" do
    @contact.short_form.should == "Doe, John"
    @contact.first_name = nil
    @contact.short_form.should == "Doe"
  end

  it "return a long form with last name, first name and company" do
    @contact.long_form.should == "Doe, John (WorldCompany)"
    @contact.company = nil
    @contact.long_form.should == "Doe, John"
    @contact.long_form.should == @contact.short_form
    @contact.first_name = nil
    @contact.long_form.should == "Doe"
  end

  it "return a clean form for mailing lists" do
    @contact.mailing_list_form.should == "Doe, John (WorldCompany) &lt;&gt;"
    @contact.email_infos << ContactInfo.new(info_type: "email", value: "jdoe@example.net")
    @contact.mailing_list_form.should == "Doe, John (WorldCompany) &lt;jdoe@example.net&gt;"
  end
end
