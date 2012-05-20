require 'spec_helper'
require 'rt_instance'

class RtInstance
  def self.dir
    Rails.root.join("spec/data/rt").to_s
  end
end

describe RtInstance do
  describe "RedmineInstance.all" do
    it "returns fake directory" do
      RtInstance.dir.should include("spec/data/rt")
    end

    it "returns all rt instances" do
      instances = RtInstance.all
      instances.size.should eq 2
      instance = instances.detect{|i| i.name == "rt_client_01"}
      instance.should be_a_kind_of RtInstance
      instance.server.should eq "rt-01"
      instance.nb_users.should eq 261
      instance.no_method.should eq ""
    end
  end
end
