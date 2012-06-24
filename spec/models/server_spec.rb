require 'spec_helper'

describe Server do
  it "is valid with just a name" do
    Server.new.should_not be_valid
    Server.new(name: "my-server").should be_valid
  end

  describe "#processor_*" do
    it "has a intelligent default value for #processor_system_count" do
      Server.new(name: "srv-01", processor_system_count: 36).processor_system_count.should == 36
      Server.new(name: "srv-01", processor_physical_count: 5).processor_system_count.should == 5
      Server.new(name: "srv-01", processor_physical_count: 5, processor_cores_per_cpu: 3).processor_system_count.should == 15
      Server.new(name: "srv-01").processor_system_count.should == 1
    end
  end

  describe "#ipaddresses" do
    let(:server) { FactoryGirl.create(:server) }

    it "updates with an address as a string" do
      server.ipaddresses = [ Ipaddress.new(address: "192.168.99.99", main: true) ]
      server.save
      server.reload
      server.read_attribute(:ipaddress).should eq 3232260963
      server.ipaddress.should eq "192.168.99.99"
    end

    it "updates with an address as a number between 1 and 32" do
      server.ipaddresses = [ Ipaddress.new(address: "24", main: true) ]
      server.save
      server.reload.should have(1).ipaddresses
      server.ipaddresses.first.address.should eq "255.255.255.0"
      server.read_attribute(:ipaddress).should eq 4294967040
      server.ipaddress.should eq "255.255.255.0"
    end

    it "leaves ip empty if no main ipaddress" do
      server.ipaddresses = [ Ipaddress.new(address: "10.0.0.1", main: true) ]
      server.save
      server.reload.ipaddress.should == "10.0.0.1"
      server.ipaddresses = [ Ipaddress.new(address: "24") ]
      server.save
      server.reload.ipaddress.should be_nil
      server.ipaddresses = [ ]
      server.save
      server.reload.ipaddress.should be_nil
    end
  end

  describe "#slug" do
    it "automaticallys generate a slug" do
      m = Server.create(name: "blah")
      m.slug.should eq "blah"
      m = Server.create(name: "( bizarr# n@me )")
      m.slug.should eq "bizarr-n-me"
    end

    pending "prevents from having 2 servers with the same identifier" do
      m1 = Server.create(name: "srv1")
      m2 = Server.new(name: "(srv1)")
      m2.should_not be_valid
      m2.slug.should eq m1.slug
      m2.errors.keys.should include(:slug)
    end
  end

  describe "#find" do
    let(:server) { FactoryGirl.create(:server) }

    it "works normally with ids" do
      Server.find(server.id).should eq server
      Server.find(server.id.to_s).should eq server
    end

    it "works with identifiers too" do
      Server.find(server.slug).should eq server
    end

    it "raises an exception if no existing record with this identifier" do
      lambda { Server.find(0) }.should raise_error Mongoid::Errors::DocumentNotFound
      lambda { Server.find("non-existent") }.should raise_error BSON::InvalidObjectId
    end
  end

  describe "scopes" do
    let!(:site1) { Site.create!(name: "eu-west") }
    let!(:site2) { Site.create!(name: "us-east") }
    let!(:rack1) { PhysicalRack.create!(name: "rack-1-eu", site_id: site1.id.to_s) }
    let!(:rack2) { PhysicalRack.create!(name: "rack-2-us", site_id: site2.id.to_s) }
    let!(:maint) { Company.create!(name: "Computer shop", is_maintainer: true) }
    let!(:os)    { OperatingSystem.create!(name: "Linux") }
    let!(:s1)    { Server.create!(name: "srv-app-01", physical_rack_id: rack1.id.to_s,
                                       maintainer_id: maint.id.to_s,
                                       operating_system_id: os.id.to_s) }
    let!(:s2)    { Server.create!(name: "srv-app-02", physical_rack_id: rack2.id.to_s,
                                       virtual: true, puppetversion: nil) }
    let!(:s3)    { Server.create!(name: "srv-db-01", physical_rack_id: rack1.id.to_s,
                                       puppetversion: "0.24.5") }

    it "filters servers by rack" do
      Server.count.should eq 3
      Server.by_rack(rack1.id.to_s).count.should eq 2
      Server.by_rack(rack2.id.to_s).count.should eq 1
    end

    it "filters servers by site" do
      Server.count.should eq 3
      Server.by_site(site1.id.to_s).count.should eq 2
      Server.by_site(site2.id.to_s).count.should eq 1
    end

    it "filters servers by location" do
      Server.by_location("site-#{site1.id}").should eq Server.by_site(site1.id.to_s)
      Server.by_location("site-0").should eq []
      Server.by_location("rack-#{rack1.id}").should eq Server.by_rack(rack1.id.to_s)
      Server.by_location("rack-0").should eq []
    end

    it "ignores the filter by location if the parameter is invalid" do
      invalid_result = Server.by_location("invalid location")
      invalid_result.should eq Server.scoped
      invalid_result.count.should eq 3
    end

    it "filters servers by maintainer" do
      Server.by_maintainer(maint.id.to_s).should eq [s1]
    end

    it "filters servers by system" do
      Server.by_system(os.id.to_s).to_a.should eq [s1]
    end

    it "filters servers by virtual" do
      Server.by_virtual(1).to_a.should eq [s2]
    end

    it "returns server with puppet installed" do
      Server.by_puppet(1).to_a.should eq [s3]
    end

    it "returns real servers only" do
      s4 = Server.create!(name: "just-a-name")
      s5 = Server.create!(name: "switch-01", network_device: true)
      s6 = Server.create!(name: "fw-01", network_device: false)
      Server.real_servers.to_a.should =~ [s1, s2, s3, s4, s6]
    end

    describe "#find_or_generate" do
      let!(:server) { Server.create(name: "rake-server") }

      it "finds server by name in priority" do
        srv = Server.find_or_generate("rake-server")
        srv.should eq server
        srv.just_created.should be_false
      end

      it "finds server by its slug if no name corresponds" do
        server.update_attribute(:name, "rake.server")
        server.name.should eq "rake.server"
        server.slug.should eq "rake-server"
        server = Server.find_or_generate("rake-server")
        server.should eq server
        server.just_created.should be_false
      end

      it "generates a new server if no match with name and identifier" do
        server = Server.where(name: "rake-server3").first
        server.should be_nil
        lambda { server = Server.find_or_generate("rake-server3") }.should change(Server, :count).by(+1)
        server.should be_persisted
        server.just_created.should be_true
      end
    end
  end

  describe "#stock?" do
    it "is truthy only if it's in a rack that is marked as stock" do
      server = FactoryGirl.create(:server)
      rack = FactoryGirl.create(:rack1)
      server.stock?.should be_false
      server.physical_rack = rack
      rack.stock?.should be_false
      server.stock?.should be_false
      rack.status = PhysicalRack::STATUS_STOCK
      rack.stock?.should be_true
      server.stock?.should be_true
    end
  end

  describe ".not_backuped" do
    let!(:server) { FactoryGirl.create(:server) }
    let!(:vm)     { FactoryGirl.create(:virtual) }

    it "includes everything by default" do
      Server.not_backuped.should include(server)
      Server.not_backuped.should include(vm)
    end

    it "does not include active servers which have an associated backup job" do
      Server.not_backuped.should include(server)
      server.backup_jobs << BackupJob.create(hierarchy: "/")
      Server.not_backuped.should_not include(server)
    end

    it "does not include servers which have a backup_exclusion" do
      Server.not_backuped.should include(server)
      BackupExclusion.create!(reason: "backuped an other way", servers: [server])
      Server.not_backuped.to_a.should_not include(server)
    end

    it "does not include net devices" do
      Server.not_backuped.should include(server)
      server.update_attribute(:network_device, true)
      Server.not_backuped.should_not include(server)
    end

    it "does not include stock servers" do
      Server.not_backuped.should include(server)
      rack = PhysicalRack.create!(name: "rack-1", site_id: FactoryGirl.create(:room).id.to_s, status: PhysicalRack::STATUS_STOCK)
      server.physical_rack = rack
      server.save
      Server.not_backuped.should_not include(server)
    end
  end

  describe "#can_be_managed_with_puppet?" do
    it "requires having an compatible os defined" do
      srv = FactoryGirl.create(:server)
      srv.operating_system.should be_blank
      srv.can_be_managed_with_puppet?.should be_false
      sys = OperatingSystem.create(name: "Ubuntu 11.10")
      srv.update_attribute(:operating_system_id, sys.id.to_s)
      srv.reload.can_be_managed_with_puppet?.should be_false
      sys.update_attribute(:managed_with_puppet, true)
      srv.reload.can_be_managed_with_puppet?.should be_true
    end
  end

  describe "#application_instances" do
    it "can have many application instance ids" do
      srv = FactoryGirl.create(:server)
      srv.application_instance_ids.should eq []
      srv.application_instances.should eq []
    end
  end

  describe "#hardware_model" do
    it "gets #model (but model is a reserved word for draper)" do
      srv = Server.create!(name: "srv-01", model: "Dell PE 2950")
      srv.hardware_model.should == "Dell PE 2950"
    end
  end

  describe "mongoid_denormalized" do
    it "updates #physical_rack_full_name correctly" do
      srv = Server.find_or_create_by(name: "srv-01")
      rack = PhysicalRack.create!(name: "Rack-01", site: Site.create!(name: "Room-A"))
      rack2 = PhysicalRack.create!(name: "Rack-02")
      srv.physical_rack_full_name.should be_blank

      srv.update_attribute(:physical_rack_id, rack2.id)
      srv.reload.physical_rack_full_name.should == "Rack-02"

      srv.update_attribute(:physical_rack_id, rack.id)
      srv.reload.physical_rack_full_name.should == "Room-A - Rack-01"

      rack.reload.update_attribute(:name, "RCK01")
      srv.reload.physical_rack_full_name.should == "Room-A - RCK01"

      rack.destroy
      srv.reload.physical_rack_full_name.should be_blank
    end

    it "updates #operating_system_name correctly" do
      srv = Server.find_or_create_by(name: "srv-01")
      sys = OperatingSystem.create!(name: "Linux")
      srv.operating_system_name.should be_blank

      srv.update_attribute(:operating_system_id, sys.id)
      srv.reload.operating_system_name.should == "Linux"

      sys.reload.update_attribute(:name, "GNU/Linux")
      srv.reload.operating_system_name.should == "GNU/Linux"

      sys.destroy
      srv.reload.operating_system_name.should be_blank
    end
  end
end
