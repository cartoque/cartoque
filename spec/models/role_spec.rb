require 'spec_helper'

describe Role do
  it "requires presence of #name" do
    Role.new.should_not be_valid
    Role.new(name: "Blah").should be_valid
  end

  it "is unique by name" do
    Role.create!(name: "Blah")
    Role.new(name: "Blah").should_not be_valid
  end

  it "is sorted by position asc by default" do
    Role.create!(name: "Two", position: 2)
    Role.create!(name: "One", position: 1)
    Role.all.to_a.map(&:name).should == %w(One Two)
  end

  it "auto increments position field" do
    Role.count.should == 0
    Role.create!(name: "One").position.should == 1
    Role.create!(name: "Two").position.should == 2
  end
end
