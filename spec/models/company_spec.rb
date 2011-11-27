require 'spec_helper'

describe Company do
  it "should have a name to be valid" do
    Company.new.should_not be_valid
    Company.new(:name => "WorldCompany").should be_valid
  end
end
