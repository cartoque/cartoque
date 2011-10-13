require 'spec_helper'
require 'rt_instance'

class RTInstance
  def self.dir
    Rails.root.join("spec/data/rt").to_s
  end
end

describe RTInstance do
  describe "RedmineInstance.all" do
    it "should return fake directory" do
      RTInstance.dir.should include("spec/data/rt")
    end

    it "should return all rt instances" do
      instances = RTInstance.all
      instances.size.should eq 2
      instance = instances.detect{|i| i.name == "rt_client_01"}
      instance.should be_a_kind_of RTInstance
      instance.server.should eq "rt-01"
      instance.nb_users.should eq 261
      instance.no_method.should eq ""
    end
  end
end
