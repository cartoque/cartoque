require 'spec_helper'

describe Mainteneur do
  it "should be valid with just a name" do
    Mainteneur.new.should_not be_valid
    Mainteneur.new(:name => "HP").should be_valid
  end
end
