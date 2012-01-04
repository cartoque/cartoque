require 'spec_helper'

describe DatabaseInstance do
  it "has a database" do
    instance = DatabaseInstance.new
    database = Factory(:database)
    #not valid without a db
    instance.should_not be_valid
    instance.errors.keys.should include :database
    #but valid with
    instance.database = database
    instance.should be_valid
    instance.database.should eq database
  end
end
