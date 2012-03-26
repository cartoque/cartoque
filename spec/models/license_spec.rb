require 'spec_helper'

describe License do
  let!(:server) { Factory(:mongo_server) }
  let!(:license1) { License.create(editor:"softcompany1", key: "XCDEZF", title: "Soft1 license") }
  let!(:license2) { License.create(editor:"softcompany2", key: "ADFRTG", server_ids: [server.id]) }

  it "should have servers" do
    license1.server_ids = [server.id]
    license1.save
    license1.reload
    license1.servers.should include server
    #inverse
    vm = MongoServer.create!(name: "vm-blah", license_ids: [license2.id])
    vm.license_ids.should include license2.id
    license2.reload.server_ids.should include vm.id
  end

  describe "scopes" do
    before do
    end

    it "should filter licenses by editor" do
      License.by_editor("softcompany2").to_a.should == [license2]
    end

    it "should filter licenses by key" do
      License.by_key("AD").to_a.should == [license2]
    end

    it "should filter licenses by title" do
      License.by_title("Soft1").to_a.should == [license1]
    end

    it "should filter licenses by server id" do
      server.licenses = [license2]
      server.save
      License.by_server(server.id).to_a.should == [license2]
    end
  end
end
