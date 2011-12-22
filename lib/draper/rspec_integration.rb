# backports https://github.com/jcasimir/draper/pull/87
# and https://github.com/jcasimir/draper/issues/60 workaround

module Draper
  module DecoratorExampleGroup
    extend ActiveSupport::Concern
    included { metadata[:type] = :decorator }
  end

  RSpec.configure do |config|
    # Automatically tag spec in specs/decorators as type: :decorator
    config.include Draper::DecoratorExampleGroup, type: :decorator, example_group: {
      file_path: /spec[\\\/]decorators/
    }

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
