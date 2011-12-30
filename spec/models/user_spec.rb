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

  describe "#seen_now!" do
    it "should update seen_on column" do
      @user.seen_on.should be_blank
      @user.seen_now!
      @user.seen_on.should_not be_blank
      @user.seen_on.should be_a Date
      (Date.today - @user.seen_on).should be < 2
    end

    it "should not save the user if not necessary" do
      @user.seen_now!
      @user.stub!(:save).and_raise(RuntimeError)
      lambda{ @user.seen_now! }.should_not raise_error
    end
  end
end
