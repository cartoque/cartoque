require 'test_helper'
require 'tomcat'

class Tomcat
  def self.dir
    File.expand_path("test/data/tomcat", Rails.root)
  end
end

class TomcatTest < ActiveSupport::TestCase
  setup do
    site1 = "site;vm-01;app01.example.com;;vip-00.example.com;TC60_01;/apps/j2ee/app01;jndi01:jdbc:postgresql://app01.db:5433/db01:app01"
    site2 = "site;vm-01;app02.example.com;;vip-00.example.com;TC60_02;/apps/j2ee/app02;jndi02:jdbc:postgresql://app02.db:1521/db02:app02"
    @app01 = Tomcat.new(site1.split(";"), "instance;vm-01;TC60_01;jdbc9;Java160;512;1024".split(";"))
    @app02 = Tomcat.new(site2.split(";"))
  end

  should "parse site and instance lines correctly" do
    expected01 = { :server => "vm-01", :dns => "app01.example.com", :vip => "vip-00.example.com",
                   :tomcat => "TC60_01", :dir => "/apps/j2ee/app01", :jdbc_url => "jndi01:jdbc:postgresql://app01.db:5433/db01:app01",
                   :jdbc_server => "app01.db:5433", :jdbc_db => "db01", :jdbc_user => "app01",
                   :jdbc_driver => "jdbc9", :java_version => "Java160", :java_xms => "512", :java_xmx => "1024" }
    assert_equal expected01, @app01

    expected02 = { :server => "vm-01", :dns => "app02.example.com", :vip => "vip-00.example.com",
                   :tomcat => "TC60_02", :dir => "/apps/j2ee/app02", :jdbc_url => "jndi02:jdbc:postgresql://app02.db:1521/db02:app02",
                   :jdbc_server => "app02.db:1521", :jdbc_db => "db02", :jdbc_user => "app02" }
    assert_equal expected02, @app02
  end

  context "Tomcat.all" do
    should "return fake directory" do
      assert Tomcat.dir.to_s.include?("test/data/tomcat")
    end

    should "return all tomcats" do
      tomcats = Tomcat.all
      assert_equal 3, tomcats.size
      assert tomcats.include?(@app01)
      assert tomcats.include?(@app02)
    end
  end
end
