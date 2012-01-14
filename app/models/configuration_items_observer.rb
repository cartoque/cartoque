class ConfigurationItemsObserver < ActiveRecord::Observer
  observe [ApplicationInstance, Application, Database, Server, Storage]

  def after_save(record)
    if record.respond_to?(:configuration_item_with_auto_creation)
      if record.configuration_item.item.blank?
        ci = record.configuration_item.dup #frozen?..
        ci.item = record
      else
        ci = record.configuration_item
      end
      ci.save
    end
  end

  def after_destroy(record)
    if record.respond_to?(:configuration_item) && record.configuration_item.present?
      record.configuration_item.destroy
    end
  end
end
