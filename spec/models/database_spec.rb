require 'spec_helper'
require 'server'

class Server
  def postgres_file
    Rails.root.join("spec/data/postgres/#{name.downcase}.txt").to_s
  end

  def oracle_file
    Rails.root.join("spec/data/oracle/#{name.downcase}.txt").to_s
  end

  def mysql_file
    Rails.root.join("spec/data/mysql/#{name.downcase}.txt").to_s	  
  end
end

describe Database do
  it "has at least a name and a type" do
    Database.new(name: "blah").should_not be_valid
    Database.new(name: "blah", type: "postgres").should be_valid
  end

  context "scopes" do
    it "filters databases by name" do
      Database.create(name: "one", type: "postgres")
      Database.create(name: "two", type: "postgres")
      Database.create(name: "three", type: "oracle")
      Database.by_name("one").map(&:name).should eq ["one"]
      Database.by_name("t").map(&:name).should eq ["two", "three"]
    end
  end

  it "returns total size handled by a database cluster server" do
    Database.new.size.should eq 0
    pg  = Database.create!(name: "pg-cluster",  type: "postgres")
    pg.database_instances.create(name: '8.4', databases:{'app01'=>1, 'app02'=>2})
    pg.database_instances.create(name: '9.0', databases:{'app01-dev'=>4, 'app02-dev'=>8})
    pg.size.should == 15
  end

  describe "#server_ids=" do
    it "should update servers correctly" do
      db = Database.create!(name: "pg-cluster", type: "postgres")
      srv = FactoryGirl.create(:server)
      vm  = FactoryGirl.create(:virtual)
      db.server_ids = [srv.id.to_s]
      db.save!
      db.reload.servers.should == [srv]
      db.server_ids = [vm.id.to_s]
      db.save!
      db.reload.servers.should == [vm]
      srv.database_id.should be_blank
    end
  end

  describe "#distribution" do
    before do
      srv = FactoryGirl.create(:server)
      vm  = FactoryGirl.create(:virtual)
      pg  = Database.create!(name: "pg-cluster",  type: "postgres", servers: [srv])
      pg.database_instances.create(name: '8.4', databases:{'app01'=>6054180, 'app02'=>293962020, 'app03'=>5341476, 'app04'=>292479268, 'app05'=>11149754660})
      pg.database_instances.create(name: '9.0', databases:{'app01-dev'=>5311356, 'app02-dev'=>6073212, 'app03-dev'=>11152252, 'app04-dev'=>17543220092})
      ora = Database.create!(name: "ora-cluster", type: "oracle",   servers: [vm])
      ora.database_instances.create(name: 'dev03', databases:{'app101'=>8755412992, 'app102'=>2144600064, 'app103'=>1191247872})
    end

    it "returns a distribution compatible with d3.js source" do
      Database.all.map(&:servers).map(&:size).should eq [1, 1]
      distrib = Database.d3_distribution
      #top key
      distrib.keys.should =~ %w(name children)
      distrib["children"].should have_exactly(3).items
      #grouped by server type
      distrib["children"].inject([]){|memo,h| memo << h["name"]}.should =~ %w(postgres oracle mysql)
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
