module Acts
  module ConfigurationItem
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_configuration_item(options = {})
        class_eval <<-"SRC"
          has_one :configuration_item, :as => :item, :autosave => false

          def ci
            self.configuration_item ||= ::ConfigurationItem.new
          end
        SRC
      end
    end
  end
end
ActiveRecord::Base.send(:include, Acts::ConfigurationItem)
