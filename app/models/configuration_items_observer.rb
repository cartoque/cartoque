class ConfigurationItemsObserver < ActiveRecord::Observer
  observe [ApplicationInstance, Database, Server, Storage]

  def after_save(record)
    if record.respond_to?(:configuration_item_with_auto_creation)
      ci = record.configuration_item
      if ci.item.blank?
        ci = ci.dup if ci.id.nil? #frozen?..
        ci.contact_ids = record.configuration_item.contact_ids
        ci.item = record
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
