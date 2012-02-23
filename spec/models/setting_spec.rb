require 'spec_helper'

describe Setting do
  describe "#safe_cas_server" do
    before do
      @default_value = Setting.fields["cas_server"].default_val
    end

    it "should return the #cas_server if set" do
      Setting.update_attribute(:cas_server, "http://cas.example.com").should be_true
      Setting.safe_cas_server.should eq "http://cas.example.com"
    end

    it "should return the default value if #cas_server is blank or nearly blanked" do
      Setting.update_attribute(:cas_server, " ").should be_true
      Setting.safe_cas_server.should eq @default_value
      @default_value.should_not be_blank
    end
  end
end
