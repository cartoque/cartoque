require 'test_helper'
require 'tomcat_old'

class TomcatOld
  def self.dir
    File.expand_path("test/data/tomcat_old", Rails.root)
  end
end

class TomcatOldTest < ActiveSupport::TestCase
  setup do
    @app = TomcatOld.new %w(srv-tomcat-01 tomcat4-app-stable 4286 j2sdk1.4.2_06 256m 256m jakarta-tomcat-4.1.31 : app01, app02)
  end

  context "Tomcat.all" do
    should "return fake directory" do
      assert TomcatOld.dir.to_s.include?("test/data/tomcat_old")
    end

    should "return all tomcats" do
      tomcats = TomcatOld.all
      assert_equal 2, tomcats.size
      assert tomcats.include?(@app), "#{tomcats.inspect} does not include #{@app.inspect}"
    end
  end

  should "parse line correctly" do
    expected = { :server => "srv-tomcat-01", :tomcat => "tomcat4-app-stable", :pid => "4286", :java => "j2sdk1.4.2_06",
                 :xms => "256m", :xmx => "256m", :home => "jakarta-tomcat-4.1.31", :apps => "app01, app02" }
    assert_equal expected, @app
  end
end
