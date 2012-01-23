require 'spec_helper'

describe ContactDecorator do
  before do
    @contact = Factory(:contact).decorate
  end

  it "return a long form with last name, first name and company" do
    @contact.decorate.long_form.should == "Doe, John (WorldCompany)"
    @contact.company = nil
    @contact.decorate.long_form.should == "Doe, John"
    @contact.first_name = nil
    @contact.decorate.long_form.should == "Doe"
  end

  it "return a clean form for mailing lists" do
    @contact.decorate.mailing_list_form.should == "Doe, John (WorldCompany) &lt;&gt;"
    @contact.email_infos << ContactInfo.new(info_type: "email", value: "jdoe@example.net")
    @contact.decorate.mailing_list_form.should == "Doe, John (WorldCompany) &lt;jdoe@example.net&gt;"
  end
end
