require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Application.new.valid?
  end
end
