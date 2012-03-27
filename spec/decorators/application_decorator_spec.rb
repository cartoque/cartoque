require 'spec_helper'

describe ApplicationDecorator do
  before do
    @a = ApplicationDecorator.new(nil) #dummy object to test methods...
  end

  describe "I18n methods" do
    it "aliases I18n.t()" do
      key = "mongoid.error.messages.invalid_time"
      @a.t(key, value: "blah").should eq I18n.t(key, value: "blah")
    end

    it "aliases I18n.l()" do
      date = Date.today
      @a.l(date).should eq I18n.l(date)
    end
  end
end
