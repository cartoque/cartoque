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

  describe "scopes" do
    before do
      @company1 = Company.create(:name => "WorldCompany", :is_maintainer => false)
      @company2 = Company.create(:name => "TinyCompany", :is_maintainer => true)
    end

    it "should return maintainers only" do
      Company.maintainers.should eq [ @company2 ]
    end
  end

  describe "#maintained_servers" do
    before do
      @company = Company.create(:name => "Wolrd company", :is_maintainer => true)
      @server1 = Server.create(:name => "srv-01", :maintainer_id => @company.id) 
      @server2 = Server.create(:name => "srv-01", :maintainer_id => nil) 
    end

    it "has some maintained servers" do
      @company.maintained_servers.should eq [ @server1 ]
    end
  end
end
