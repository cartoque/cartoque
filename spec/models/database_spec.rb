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
  it "should have at least a name and a type" do
    Database.new(name: "blah").should_not be_valid
    Database.new(name: "blah", type: "postgres").should be_valid
  end

  context "scopes" do
    it "should filter databases by name" do
      Database.create(name: "one", type: "postgres")
      Database.create(name: "two", type: "postgres")
      Database.create(name: "three", type: "oracle")
      Database.by_name("one").map(&:name).should eq ["one"]
      Database.by_name("t").map(&:name).should eq ["two", "three"]
    end
  end

  it "should return a postgres report" do
    d = FactoryGirl.create(:database)
    d.should_not be_nil
    d.servers.size.should eq 1
    d.oracle_report.should be_blank
    d.postgres_report.should be_present
    d.postgres_report.size.should eq 2
    d.instances.should eq 2
  end

  it "should return an oracle report" do
    d = FactoryGirl.create(:oracle)
    d.should_not be_nil
    d.servers.size.should eq 1
    d.oracle_report.should be_present
    d.postgres_report.should be_blank
    d.oracle_report.size.should eq 1
    d.instances.should eq 1
  end

  it "should return 0 if no report at all" do
    Database.new.instances.should eq 0
  end

  it "should return a postgres_report if postgres, oracle if oracle, empty array if no type" do
    d = FactoryGirl.create(:database)
    d.postgres_report.size.should eq 2
    d.report.size.should eq 2
    Database.new.report.should eq []
  end

  it "should return total size handled by a database cluster server" do
    Database.new.size.should eq 0
    FactoryGirl.create(:database).size.should eq 29313348516
    FactoryGirl.create(:oracle).size.should eq 12091260928
  end

  describe "#distriution" do
    before do
      srv = FactoryGirl.create(:server)
      vm  = FactoryGirl.create(:virtual)
      Database.create!(name: "pg-cluster",  type: "postgres", servers: [srv])
      Database.create!(name: "ora-cluster", type: "oracle",   servers: [vm])
    end

    it "returns a distribution compatible with d3.js source" do
      Database.all.map(&:servers).map(&:size).should eq [1, 1]
      distrib = Database.d3_distribution
      #top key
      distrib.keys.should =~ %w(name children)
      distrib["children"].should have_exactly(2).items
      #grouped by server type
      distrib["children"].inject([]){|memo,h| memo << h["name"]}.should =~ %w(postgres oracle)
      #grouped by clusters
      pg = distrib["children"].detect{|h| h["name"] == "postgres"}["children"]
      pg.should have_exactly(1).item
      pg.first["name"].should == "pg-cluster"
      #grouped by db engines
      dbs = pg.first["children"].first["children"]
      dbs_str = dbs.map{|h| "#{h["name"]}:#{h["size"]}"}.sort.join(" ")
      dbs_str.should == "app01:6054180 app02:293962020 app03:5341476 app04:292479268 app05:11149754660"
    end

    it "defaults to Database.all" do
      Database.d3_distribution.should eq Database.d3_distribution(Database.includes(:servers))
    end
  end
end
