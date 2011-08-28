require 'test_helper'

class ServerTest < ActiveSupport::TestCase
  should "be valid" do
    assert ! Server.new.valid?
    assert Server.new(:name => "my-server").valid?
  end

  context "#ipaddresses" do
    setup do
      @server = Factory(:server)
    end

    should "update with an address as a string" do
      @server.ipaddresses = [ Ipaddress.new(:address => "192.168.99.99", :main => true) ]
      @server.save
      @server.reload
      assert_equal 3232260963, @server.read_attribute(:ipaddress)
      assert_equal "192.168.99.99", @server.ipaddress
    end

    should "update with an address as a number between 1 and 32" do
      @server.ipaddresses = [ Ipaddress.new(:address => "24", :main => true) ]
      @server.save
      assert_equal 1, @server.reload.ipaddresses.count
      assert_equal "255.255.255.0", @server.ipaddresses.first.address
      assert_equal 4294967040, @server.read_attribute(:ipaddress)
      assert_equal "255.255.255.0", @server.ipaddress
    end

    should "leave ip empty if no main ipaddress" do
      @server.ipaddresses = [ Ipaddress.new(:address => "24", :main => true) ]
      @server.save
      assert_not_nil @server.reload.ipaddress
      @server.ipaddresses = [ Ipaddress.new(:address => "24") ]
      @server.save
      assert_nil @server.reload.ipaddress
      @server.ipaddresses = [ ]
      @server.save
      assert_nil @server.reload.ipaddress
    end
  end

  context "details" do
    setup do
      @server = Factory(:server)
    end

    should "display cpu" do
      assert_equal "4 * 4 cores, 3.2 GHz<br />(Xeon 2300)", @server.cpu
      @server.nb_coeur = nil
      assert_equal "4 * 3.2 GHz<br />(Xeon 2300)", @server.cpu
      @server.nb_coeur = 1
      assert_equal "4 * 3.2 GHz<br />(Xeon 2300)", @server.cpu
    end

    should "display ram" do
      assert_equal "42", @server.ram
    end

    should "display disks" do
      assert_equal "5 * 13G (SAS)", @server.disks
    end
  end

  context "#identifier" do
    should "automatically generate an identifier" do
      m = Server.create(:name => "blah")
      assert_equal "blah", m.identifier
      m = Server.create(:name => "( bizarr# n@me )")
      assert_equal "bizarr-n-me", m.identifier
    end

    should "prevent from having 2 servers with the same identifier" do
      m1 = Server.create(:name => "srv1")
      m2 = Server.new(:name => "(srv1)")
      assert ! m2.valid?
      assert_equal m1.identifier, m2.identifier
      assert m2.errors.keys.include?(:identifier)
    end
  end

  context "#find" do
    setup do
      @server = Factory(:server)
    end

    should "work normally with ids" do
      assert_equal @server, Server.find(@server.id)
      assert_equal @server, Server.find(@server.id.to_s)
    end

    should "work with identifiers too" do
      assert_equal @server, Server.find(@server.identifier)
    end

    should "raise an exception if no existing record with this identifier" do
      assert_raise ActiveRecord::RecordNotFound do
        Server.find("non-existent")
      end
    end
  end
end
