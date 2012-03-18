require 'spec_helper'

describe ApplicationDecorator do
  before do
    @a = ApplicationDecorator.new(nil) #dummy object to test methods...
  end

  describe "I18n methods" do
    it "aliases I18n.t()" do
      key = "activerecord.messages.less_than"
      @a.t(key, count: 2).should eq I18n.t(key, count: 2)
    end

    it "aliases I18n.l()" do
      date = Date.today
      @a.l(date).should eq I18n.l(date)
    end
  end
end
