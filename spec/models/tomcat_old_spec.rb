require 'spec_helper'
require 'tomcat_old'

class TomcatOld
  def self.dir
    File.expand_path("test/data/tomcat_old", Rails.root)
  end
end

describe TomcatOld do
  before do
    @app = TomcatOld.from_array %w(srv-tomcat-01 tomcat4-app-stable 4286 j2sdk1.4.2_06 256m 
                                   256m jakarta-tomcat-4.1.31 : app01, app02)
  end

  describe "Tomcat.all" do
    it "should return fake directory" do
      TomcatOld.dir.to_s.should include("test/data/tomcat_old")
    end

    it "should return all tomcats" do
      tomcats = TomcatOld.all
      tomcats.size.should eq 2
      tomcats.should include(@app) #"#{tomcats.inspect} does not include #{@app.inspect}"
    end
  end

  it "should parse line correctly" do
    expected = { "server" => "srv-tomcat-01", "tomcat" => "tomcat4-app-stable", "pid" => "4286", "java" => "j2sdk1.4.2_06",
                 "xms" => "256m", "xmx" => "256m", "home" => "jakarta-tomcat-4.1.31", "apps" => "app01, app02" }
    @app.should eq expected
  end
end
