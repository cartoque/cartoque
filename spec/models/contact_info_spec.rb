require 'spec_helper'

describe ContactInfo do
  let(:contact) { FactoryGirl.create(:contact) }

  it "has all fields to be valid" do
    info = EmailInfo.new
    info.should_not be_valid
    info.should have_exactly(2).errors
    info.entity = FactoryGirl.create(:contact)
    info.value = "555-123456"
    info.should be_valid
  end

  it "displays value when using #to_s" do
    EmailInfo.new(value: "blah").to_s.should eq "blah"
  end
end
