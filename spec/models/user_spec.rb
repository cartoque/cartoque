require 'spec_helper'

describe User do
  before do
    @user = Factory(:user)
  end

  it "should have a unique name" do
    other = User.new(:name => @user.name)
    other.should_not be_valid
    other.errors.keys.should == [:name]
    other.errors[:name].should == [I18n.t("activerecord.errors.messages.taken")]
  end

  it "should have a contextual datacenter" do
    Datacenter.count.should == 0
    @user.datacenter.should_not be_blank
    @user.datacenter.name.should == "Datacenter"
    Datacenter.count.should == 1
  end

  it "should have a unique provider+uid" do

    
  end

  describe "#settings" do
    it "should always be a hash" do
      @user.update_attribute(:settings, nil)
      @user.reload.settings.should eq Hash.new
    end

    it "should serialize settings" do
      hsh = { :a => "b" }
      @user.settings = hsh
      @user.save
      @user.reload.settings.should eq hsh
    end
  end

  describe "#set_setting" do
    it "should set a setting (without saving the user)" do
      @user.settings.should be_blank
      @user.set_setting(:a, "b")
      @user.save
      @user.reload.settings[:a].should eq "b"
    end
  end

  describe "#update_setting" do
    it "should set a setting and save the user" do
      @user.settings.should be_blank
      @user.update_setting(:a, "b")
      @user.reload.settings[:a].should eq "b"
    end
  end
end
