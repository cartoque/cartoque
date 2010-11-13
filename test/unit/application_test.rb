require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  should "be valid" do
    assert Application.new.valid?
  end
end
