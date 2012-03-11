require 'spec_helper'

describe License do
  describe "scopes" do
    before do
      @server = Factory(:server)
      @license1 = License.create(:editor=>"softcompany1", :key => "XCDEZF", :title => "Soft1 license")
      @license2 = License.create(:editor=>"softcompany2", :key => "ADFRTG") #, :server_ids => [@server.to_param])
    end

    it "should filter licenses by editor" do
      licenses = License.by_editor("softcompany2")
      licenses.should include(@license2)
      licenses.should_not include(@license1)
    end

    it "should filter licenses by key" do
      licenses = License.by_key("AD")
      licenses.should include(@license2)
      licenses.should_not include(@license1)
    end

    it "should filter licenses by title" do
      licenses = License.by_title("Soft1")
      licenses.should include(@license1)
      licenses.should_not include(@license2)
    end

    it "should filter licenses by server id" do
      ActiveRecord::Base.connection.execute("INSERT INTO licenses_servers (server_id, license_mongo_id) VALUES(#{@server.id}, '#{@license2.to_param}');")
      licenses = License.by_server(@server.id)
      licenses.should include(@license2)
      licenses.should_not include(@license1)
    end
  end

  pending "should have servers" do
    license.server_ids = [@server.to_param]
  end
end
