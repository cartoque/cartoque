require 'test_helper'

class DatabaseTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ! Database.new(:name => "blah").valid?
    assert Database.new(:name => "blah", :database_type => "postgres").valid?
  end

  should "return a valid report" do
  end
end
