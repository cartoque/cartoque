require 'spec_helper'

#let's change Tomcat.dir
#TODO: a bit ugly, make it better!
require 'tomcat'
class Tomcat
  def self.dir
    File.expand_path("spec/data/tomcat", Rails.root)
  end
end

describe Tomcat do
  before do
    site1 = "site;vm-01;app01.example.com;;vip-00.example.com;TC60_01;/apps/j2ee/app01;jndi01:jdbc:postgresql://app01.db:5433/db01:app01"
    site2 = "site;vm-01;app02.example.com;;vip-01.example.com;TC60_02;/apps/j2ee/app02;jndi02:jdbc:postgresql://app02.db:1521/db02:app02"
    @app01 = Tomcat.new(site1.split(";"), { :instance => "instance;vm-01;TC60_01;jdbc9;Java160;512;1024".split(";") })
    @app02 = Tomcat.new(site2.split(";"))
  end

  it "should parse site and instance lines correctly" do
    expected01 = { "server" => "vm-01", "dns" => "app01.example.com", "vip" => "vip-00.example.com",
                   "tomcat" => "TC60_01", "dir" => "/apps/j2ee/app01", "jdbc_url" => "jndi01:jdbc:postgresql://app01.db:5433/db01:app01",
                   "jdbc_server" => "app01.db:5433", "jdbc_db" => "db01", "jdbc_user" => "app01",
                   "jdbc_driver" => "jdbc9", "java_version" => "Java160", "java_xms" => "512", "java_xmx" => "1024",
                   "cerbere" => false, "cerbere_csac" => false, "crons" => [] }
    @app01.to_hash.should eq expected01

    expected02 = { "server" => "vm-01", "dns" => "app02.example.com", "vip" => "vip-01.example.com",
                   "tomcat" => "TC60_02", "dir" => "/apps/j2ee/app02", "jdbc_url" => "jndi02:jdbc:postgresql://app02.db:1521/db02:app02",
                   "jdbc_server" => "app02.db:1521", "jdbc_db" => "db02", "jdbc_user" => "app02",
                   "cerbere" => false, "cerbere_csac" => false, "crons" => [] }
    @app02.to_hash.should eq expected02
  end

  context "Tomcat.all" do
    it "should return fake directory" do
      Tomcat.dir.to_s.should include("spec/data/tomcat")
    end

    it "should return all tomcats" do
      tomcats = Tomcat.all
      tomcats.size.should eq 3
      tomcats.should include(@app01)
      tomcats.should include(@app02)
    end
  end

  context "Tomcat.find_for_server" do
    it "should return an empty array if no tomcat found" do
      Tomcat.find_for_server("not-a-tomcat-server").should eq []
    end

    it "should return tomcats for a specific server" do
      tomcats = Tomcat.find_for_server("vm-01")
      tomcats.size.should eq 2
      tomcats.should include(@app01)
      tomcats.should include(@app02)
    end

    it "should be retrieved with Server#tomcats" do
      tomcats = Server.find_or_create_by_name("vm-01").tomcats
      tomcats.size.should eq 2
      tomcats.should include(@app01)
      tomcats.should include(@app02)
    end
  end

  context "Tomcat.filters_from" do
    it "should return values from hashes" do
      tomcats = [{"key" => "value1"}, {"key" => "value2"}]
      Tomcat.filters_from(tomcats).should eq({"key" => ["value1", "value2"]})
    end

    it "should avoid 'cerbere' and 'cerbere_csac' keys" do
      tomcats = [{"cerbere" => true, "cerbere_csac" => false}]
      Tomcat.filters_from(tomcats).should eq({})
    end

    it "should reduce 'tomcat' key to the first part before an underscore" do
      tomcats = [{:tomcat => "TC60_01"}, {:tomcat => "TC60_02"}]
      Tomcat.filters_from(tomcats).should eq({"tomcat" => ["TC60"]})
    end

    it "should return an array if key doesn't exist" do
      Tomcat.filters_from([]).non_existent_key.should eq []
    end
  end

  context "Tomcat.filter_collection" do
    before do
      @tomcats = [ @app01, @app02 ]
    end

    it "should filter nothing if no params by_* given" do
      Tomcat.filter_collection(@tomcats, {:key => "value"}).should eq @tomcats
    end

    it "should apply filters" do
      #beginning of vip
      Tomcat.filter_collection(@tomcats, {:by_vip => "vip-0"}).should eq @tomcats
      Tomcat.filter_collection(@tomcats, {:by_vip => "vip-00"}).should eq [@app01]
      #server
      Tomcat.filter_collection(Tomcat.all, {:by_server => "vm-01"}).should eq [@app01, @app02]
      #beginning of tomcat
      Tomcat.filter_collection(Tomcat.all, {:by_tomcat => "TC60_02"}).should eq [@app02]
      #beginning of java_version
      Tomcat.filter_collection(@tomcats, {:by_java => "Java160"}).should eq [@app01]
    end
  end
end
