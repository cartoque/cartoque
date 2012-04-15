# backports https://github.com/jcasimir/draper/pull/87
# and https://github.com/jcasimir/draper/issues/60 workaround
# (with maybe some additions)

require 'draper/rspec_integration'

module Draper
  RSpec.configure do |config|
    # Specs tagged type: :decorator set the Draper view context
    config.around do |example|
      if :decorator == example.metadata[:type]
        controller = ApplicationController.new
        controller.request = ActionDispatch::TestRequest.new
        controller.set_current_view_context
      end
      example.call
    end
  end
end
