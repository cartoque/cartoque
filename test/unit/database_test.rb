require 'test_helper'

class DatabaseTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Database.new(:name => "blah").valid?
  end
end
