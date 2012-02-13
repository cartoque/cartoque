module Acts
  module ConfigurationItem
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_configuration_item(options = {})
        class_eval <<-"SRC"
          has_one :configuration_item, as: :item, autosave: false

          def configuration_item_with_auto_creation
            self.configuration_item_without_auto_creation || (self.configuration_item = ::ConfigurationItem.new)
          end
          alias_method_chain :configuration_item, :auto_creation
        SRC
      end
    end
  end
end
ActiveRecord::Base.send(:include, Acts::ConfigurationItem)
