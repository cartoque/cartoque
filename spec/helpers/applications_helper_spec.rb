require 'spec_helper'

describe ApplicationsHelper do
  it "#collection_for_authentication_methods" do
    select = collection_for_authentication_methods
    assert select.include?(["Interne", "internal"])
    assert_equal ApplicationInstance::AVAILABLE_AUTHENTICATION_METHODS.size, select.size
  end
end
