require 'spec_helper'

describe DatabaseInstance do
  let(:database) { Database.create!(name: "srv-01", type: "postgres") }
  let(:database2) { Database.create!(name: "srv-02", type: "postgres") }

  it "has at least a name and a database" do
    lambda { database.database_instances.create! }.should raise_error
    lambda { database.database_instances.create!(name: "blah", databases: nil) }.should raise_error
    lambda { database.database_instances.create!(name: "blah") }.should_not raise_error
    database.database_instances.first.databases.should == {}
    lambda { database.database_instances.create!(name: "bleh", databases: {}) }.should_not raise_error
  end

  it "guarantees uniqueness of name in a single database" do
    lambda { database.database_instances.create!(name: "blah", databases: {}) }.should_not raise_error
    lambda { database.database_instances.create!(name: "blah", databases: {}) }.should raise_error
    lambda { database2.database_instances.create!(name: "blah", databases: {}) }.should_not raise_error
  end

  it "calculates the size of its databases" do
    database.database_instances.create!(name: "blah", databases: { first: 1, two: 2, three: 3 })
    database.database_instances.last.size.should == 6
    database.database_instances.create!(name: "bleh", databases: {})
    database.database_instances.last.size.should == 0
  end
end
