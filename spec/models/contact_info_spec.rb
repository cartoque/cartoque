require 'spec_helper'

describe ContactInfo do
  let(:contact) { Factory.create(:contact) }

  it "should have all fields to be valid" do
    info = EmailInfo.new
    info.should_not be_valid
    info.should have_exactly(2).errors
    info.entity = Factory(:contact)
    info.value = "555-123456"
    info.should be_valid
  end

  it "should display value when using #to_s" do
    EmailInfo.new(value: "blah").to_s.should eq "blah"
  end
end
