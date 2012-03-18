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
    EmailInfo.create(value: "jdoe@example.net", entity: @contact)
    @contact.mailing_list_form.should == "Doe, John (WorldCompany) &lt;jdoe@example.net&gt;"
  end

  describe "#to_html" do
    it "gives an html version of the contact" do
      @contact.to_html.should have_selector("a", text: "Doe, John") 
    end

    it "accepts a parameter to format the contact name" do
      @contact.to_html(:long_form).should have_selector("a", text: "Doe, John (WorldCompany)")
    end
  end
end
