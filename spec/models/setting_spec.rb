require 'spec_helper'

describe Setting do
  describe "#safe_cas_server" do
    before do
      Settler.load!
      @setting = Setting.find_or_create_by_key(:key => "cas_server")
      #don't hardcode this because Psyck is buggy in mri p180, yaml anchors are not merged correctly
      @default_value = Settler.config["cas_server"]["value"]
    end

    it "should return the #cas_server if set" do
      @setting.update_attribute(:value, "http://cas.example.com").should be_true
      Settler.safe_cas_server.should eq "http://cas.example.com"
    end

    it "should return the default value if #cas_server is blank or nearly blanked" do
      @setting.update_attribute(:value, " ").should be_true
      Settler.safe_cas_server.should eq @default_value
    end

    it "should return the default value if #cas_server is missing" do
      @setting.delete
      Settler.cas_server.should be_blank
      Settler.safe_cas_server.should eq @default_value
    end
  end
end
