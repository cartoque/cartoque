module Acts
  module ConfigurationItem
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_configuration_item(options = {})
        class_eval <<-"SRC"
          has_one :configuration_item, :as => :item
        SRC
      end
    end
  end
end
ActiveRecord::Base.send(:include, Acts::ConfigurationItem)
