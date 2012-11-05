require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end

  it "has a unique name" do
    other = User.new(name: @user.name)
    other.should_not be_valid
    other.errors.keys.should == [:name]
    other.errors[:name].should == [I18n.t("mongoid.errors.messages.taken")]
  end

  it "has a contextual datacenter" do
    Datacenter.destroy_all
    User.destroy_all
    Datacenter.count.should == 0

    user = FactoryGirl.create(:user)
    user.preferred_datacenter.should be_present
    user.preferred_datacenter.should be_persisted
  end

  it "has a unique provider+uid" do

    
  end

  describe "#settings" do
    it "alwayss be a hash" do
      User.new.settings.should eq Hash.new
    end

    it "serializes settings" do
      hsh = { "a" => "b" }
      @user.settings = hsh
      @user.save
      @user.reload.settings.should eq hsh
    end
  end

  describe "#set_setting" do
    it "sets a setting (without saving the user)" do
      @user.settings.should be_blank
      @user.set_setting("a", "b")
      @user.save
      @user.reload.settings["a"].should eq "b"
    end
  end

  describe "#update_setting" do
    it "sets a setting and save the user" do
      @user.settings.should be_blank
      @user.update_setting("a", "b")
      @user.reload.settings["a"].should eq "b"
    end

    it "stringifys key" do
      @user.settings.should be_blank
      @user.update_setting(:a, "c")
      @user.reload.settings["a"].should eq "c"
    end
  end

  describe "#visible_datacenters" do
    it "accepts datacenters" do
      datacenter = FactoryGirl.create(:datacenter)
      @user.update_attribute(:visible_datacenter_ids, [datacenter.id.to_s])
      @user.reload.visible_datacenters.should eq [datacenter]
    end
  end
end
