require 'spec_helper'

describe Company do
  it "should have a name to be valid" do
    Company.new.should_not be_valid
    Company.new(name: "WorldCompany").should be_valid
    Company.new(name: "WorldCompany").image_url.should == "building.png"
  end

  describe "#search" do
    before do
      @company1 = Company.create(name: "WorldCompany")
      @company2 = Company.create(name: "TinyCompany")
    end

    it "should return everything if parameter is blank" do
      Company.like("").to_a.should =~ [@company1, @company2]
    end
    
    it "should filter companys by name" do
      Company.like("World").to_a.should =~ [@company1]
      Company.like("Tiny").to_a.should =~ [@company2]
      Company.like("Comp").to_a.should =~ [@company1, @company2]
    end
  end

  describe "scopes" do
    before do
      @company1 = Company.create(name: "WorldCompany", is_maintainer: false)
      @company2 = Company.create(name: "TinyCompany", is_maintainer: true)
    end

    it "should return maintainers only" do
      Company.maintainers.to_a.should =~ [ @company2 ]
    end
  end

  describe "#maintained_servers" do
    before do
      @company = Company.create(name: "Wolrd company", is_maintainer: true)
      @server1 = Server.create(name: "srv-01", maintainer_mongo_id: @company.id.to_s)
      @server2 = Server.create(name: "srv-01", maintainer_mongo_id: nil) 
    end

    it "has some maintained servers" do
      @company.maintained_servers.to_a.should =~ [ @server1 ]
    end
  end
end
