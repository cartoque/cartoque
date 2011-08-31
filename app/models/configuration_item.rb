class ConfigurationItem < ActiveRecord::Base
  belongs_to :item, :polymorphic => true

  validates_presence_of :item

  before_validation :update_identifier!

  scope :by_item_type, proc {|type| where(:item_type => type) }

  def update_identifier!
    if self.item.present?
      self.identifier = "#{self.item_type.downcase}::#{self.item.to_s.try(:parameterize)}"
    end
  end

  def self.real_object_classes
    @@real_object_classes ||= ActiveRecord::Base.subclasses.select do |klass|
      klass != ConfigurationItem && klass.instance_methods.include?(:configuration_item)
    end
  end
end
