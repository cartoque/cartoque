require 'spec_helper'

describe ServerDecorator do
  let(:server) { ServerDecorator.decorate(FactoryGirl.create(:server)) }

  describe "#badges" do
    it "is empty if the server has no badge" do
      server.badges.should == ""
    end

    it "concatenates all the badges for a server" do
      server.network_device = true
      server.virtual = true
      server.puppetversion = "2.6"
      badges = server.badges
      badges.should have_selector("div", count: 3)
    end
  end

  describe "#network_device_badge" do
    it "is empty for normal servers" do
      server.network_device_badge.should == ""
    end

    it "displays an image for network devices" do
      server.network_device = true
      server.network_device_badge.should have_selector("div>img")
    end
  end
  
  describe "#puppet_badge" do
    it "is empty for non-puppetized servers" do
      server.puppet_badge.should == ""
    end

    it "displays a P if puppetversion is present" do
      server.puppetversion = "2.6"
      server.puppet_badge.should have_selector("div", text: "P")
    end
  end
  
  describe "#virtual_badge" do
    it "is empty for physical servers" do
      server.virtual_badge.should == ""
    end

    it "displays a V for virtual machines" do
      server.virtual = true
      server.virtual_badge.should have_selector("div", text: "V")
    end
  end

  describe "hardware details" do
    it "should display cpu" do
      server.cpu.should eq %(4 * 4 cores, 3.2 GHz<span class="processor-reference">Xeon 2300</span>)
      server.processor_cores_per_cpu = nil
      server.cpu.should eq %(4 * 3.2 GHz<span class="processor-reference">Xeon 2300</span>)
      server.processor_cores_per_cpu = 1
      server.cpu.should eq %(4 * 3.2 GHz<span class="processor-reference">Xeon 2300</span>)
    end

    it "should display ram" do
      server.memory.should eq "42GB"
    end

    it "should display disks" do
      server.disks.should eq "5 * 13G (SAS)"
    end
  end

  describe "#short_line" do
    it "should display server with full details" do
      line = server.short_line
      line.should have_selector(:css, "span.server-link a", text: "server-01")
      line.should have_selector(:css, "span.server-summary", text: "4 * 4 cores, 3.2 GHz | 42GB | 5 * 13G (SAS)")
    end

    it "should display server without raising an exception if no details" do
      #TODO: restore this when switching back to "Server"
      #line = Server.new(name: "server-03").decorate.short_line
      line = ServerDecorator.decorate(Server.new(name: "server-03")).short_line
      line.should have_selector(:css, "span.server-link a", text: "server-03")
    end

    it "should display nothing in server details if no details available" do
      #TODO: restore this when switching back to "Server"
      #line = Server.new(name: "srv").decorate.short_line
      line = ServerDecorator.decorate(Server.new(name: "srv")).short_line
      line.should have_selector(:css, "span.server-summary", text: "")
    end
  end

  describe "#maintenance_limit" do
    it "returns 'no' if maintenance end date is blank" do
      server.maintenance_limit.should have_selector(:css, "span.maintenance-critical", text: I18n.t(:word_no))
    end

    it "returns the date if server is maintained until the next 2 years" do
      server.maintained_until = Date.today + 2.years
      server.maintenance_limit.should == I18n.l(server.maintained_until)
    end

    it "returns warning or critical <span> if under 6 or 12 months" do
      server.maintained_until = Date.today - 2.years
      server.maintenance_limit.should have_selector(:css, "span.maintenance-critical")
      server.maintained_until = Date.today + 5.months
      server.maintenance_limit.should have_selector(:css, "span.maintenance-critical")
      server.maintained_until = Date.today + 11.months
      server.maintenance_limit.should have_selector(:css, "span.maintenance-warning")
    end
  end
end
