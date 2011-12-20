require 'spec_helper'

describe Role do
  it "requires presence of #name" do
    Role.new.should_not be_valid
    Role.new(:name => "Blah").should be_valid
  end

  it "should be unique by name" do
    Role.create!(:name => "Blah")
    Role.new(:name => "Blah").should_not be_valid
  end
end
