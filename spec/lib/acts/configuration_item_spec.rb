require 'spec_helper'

#fake models without correct prerequisites
class NotAMongoidClass1; def self.default_scope; end; end
class NotAMongoidClass2; def self.has_and_belongs_to_many; end; end

#fake model with correct prerequisites
class CIModel
  include Mongoid::Document
  include Acts::ConfigurationItem
end

describe Acts::ConfigurationItem do
  describe 'missing pre-requisite' do
    it 'raises if the class does not respond to has_and_belongs_to_many' do
      expect do
        NotAMongoidClass1.send(:include, Acts::ConfigurationItem)
      end.to raise_error Acts::ConfigurationItem::MissingPrerequisite, /has_and_belongs/
    end

    it 'raises if the class does not respond to has_many' do
      expect do
        NotAMongoidClass2.send(:include, Acts::ConfigurationItem)
      end.to raise_error Acts::ConfigurationItem::MissingPrerequisite, /default_scope/
    end
  end

  describe 'scopes model to datacenter' do
    #
    # All tests below are run with the "Server" model, which means the behaviour
    # is not completely tested at a unit level application-wide. This would mean
    # a lot more unit tests with no real added value. If somebody has an idea
    # about how to test that more generally...
    #
    before do
      @bob         = FactoryGirl.create(:bob)
      @datacenter1 = FactoryGirl.create(:datacenter)
      @datacenter2 = FactoryGirl.create(:datacenter, name: "Phoenix")
      @server1     = FactoryGirl.create(:server, name: "server1")
      @server2     = FactoryGirl.create(:server, name: "server2")
      @server1.datacenters = [@datacenter1]
      @server1.save
      @server2.datacenters = [@datacenter2]
      @server2.save
    end

    after do
      User.current = nil
    end

    it 'sees everything if there is no User.current' do
      Server.all.to_a.should =~ [@server1, @server2]
    end

    it 'does not see anything if no visible_datacenters configured at user level' do
      User.current = @bob
      Server.all.to_a.should =~ []
    end

    it 'only sees servers in visible datacenters' do
      @bob.visible_datacenters = [@datacenter1]
      @bob.save
      User.current = @bob
      Server.all.to_a.should =~ [@server1]
    end

    it 'also scopes things for find method' do
      @bob.visible_datacenters = [@datacenter1]
      @bob.save
      User.current = @bob
      expect { Server.find(@server2.id) }.to raise_error Mongoid::Errors::DocumentNotFound
    end

    it 'sees servers in one datacenter if user has many datacenters' do
      @bob.visible_datacenters = [@datacenter1, FactoryGirl.create(:datacenter, name: "Paris")]
      @bob.save
      User.current = @bob
      Server.all.to_a.should =~ [@server1]
    end

    it 'always finds servers that have no datacenter information if user is present' do
      @server3 = FactoryGirl.create(:server, name: "server3")
      User.current = @bob
      Server.all.to_a.should =~ [@server3]
      @bob.visible_datacenters = [@datacenter1]
      @bob.save
      Server.all.to_a.should =~ [@server1, @server3]
    end

  end
end
