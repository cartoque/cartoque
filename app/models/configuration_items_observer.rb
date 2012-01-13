class ConfigurationItemsObserver < ActiveRecord::Observer
  observe [ApplicationInstance, Application, Database, Server, Storage]

  def after_save(record)
    if record.respond_to?(:ci)
      if record.ci.item.blank?
        ci = record.ci.dup #frozen?..
        ci.item = record
      else
        ci = record.ci
      end
      ci.save
    end
  end

  def after_destroy(record)
    if record.respond_to?(:configuration_item) && record.configuration_item.present?
      record.ci.destroy
    end
  end
end
