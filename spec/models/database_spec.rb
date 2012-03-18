require 'spec_helper'
require 'server'

class Server
  def postgres_file
    Rails.root.join("spec/data/postgres/#{name.downcase}.txt").to_s
  end

  def oracle_file
    Rails.root.join("spec/data/oracle/#{name.downcase}.txt").to_s
  end
end

describe Database do
  it "should have at least a name and a database_type" do
    Database.new(name: "blah").should_not be_valid
    Database.new(name: "blah", database_type: "postgres").should be_valid
  end

  context "scopes" do
    it "should filter databases by name" do
      Database.create(name: "one", database_type: "postgres")
      Database.create(name: "two", database_type: "postgres")
      Database.create(name: "three", database_type: "oracle")
      Database.by_name("one").map(&:name).should eq ["one"]
      Database.by_name("t").map(&:name).should eq ["two", "three"]
    end
  end

  it "should return a postgres report" do
    d = Factory(:database)
    d.should_not be_nil
    d.oracle_report.should be_blank
    d.postgres_report.should be_present
    d.postgres_report.size.should eq 2
    d.instances.should eq 2
  end

  it "should return an oracle report" do
    d = Factory(:oracle)
    d.should_not be_nil
    d.oracle_report.should be_present
    d.postgres_report.should be_blank
    d.oracle_report.size.should eq 1
    d.instances.should eq 1
  end

  it "should return 0 if no report at all" do
    Database.new.instances.should eq 0
  end

  it "should return a postgres_report if postgres, oracle if oracle, empty array if no database_type" do
    d = Factory(:database)
    d.postgres_report.size.should eq 2
    d.report.size.should eq 2
    Database.new.report.should eq []
  end

  it "should return total size handled by a database cluster server" do
    Database.new.size.should eq 0
    Factory(:database).size.should eq 29313348516
    Factory(:oracle).size.should eq 12091260928
  end
end
