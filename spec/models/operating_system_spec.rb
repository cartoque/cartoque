require 'spec_helper'

describe OperatingSystem do
  it "should be valid with just a name" do
    system = OperatingSystem.new
    system.should_not be_valid
    system.name = "Linux"
    system.should be_valid
  end
end
