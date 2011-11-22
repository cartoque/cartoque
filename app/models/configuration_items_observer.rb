class ConfigurationItemsObserver < ActiveRecord::Observer
  observe [ApplicationInstance, Application, Database, Server, Storage]

  def after_save(record)
    ConfigurationItem.generate_ci_for(record) if record.respond_to?(:configuration_item)
  end

  def after_destroy(record)
    if record.respond_to?(:configuration_item) && record.configuration_item.present?
      record.configuration_item.destroy
    end
  end
end
