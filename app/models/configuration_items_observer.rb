Dir.glob(Rails.root.join('app/models/*.rb')).each { |file| require file }

class ConfigurationItemsObserver < ActiveRecord::Observer
  observe ActiveRecord::Base.subclasses - [ConfigurationItem]

  def after_save(record)
    if record.respond_to?(:configuration_item)
      if record.configuration_item.blank?
        ConfigurationItem.create!(:item => record)
      else
        record.configuration_item.save
      end
    end
  end

  def after_destroy(record)
    if record.respond_to?(:configuration_item) && record.configuration_item.present?
      record.configuration_item.destroy
    end
  end
end
