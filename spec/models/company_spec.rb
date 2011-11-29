require 'spec_helper'

describe Company do
  it "should have a name to be valid" do
    Company.new.should_not be_valid
    Company.new(:name => "WorldCompany").should be_valid
  end

  describe "#search" do
    before do
      @company1 = Company.create(:name => "WorldCompany")
      @company2 = Company.create(:name => "TinyCompany")
    end

    it "should return everything if parameter is blank" do
      Company.search("").should eq [@company1, @company2]
    end
    
    it "should filter companys by name" do
      Company.search("World").should eq [@company1]
      Company.search("Tiny").should eq [@company2]
      Company.search("Comp").should eq [@company1, @company2]
    end
  end
end
