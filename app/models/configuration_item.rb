class ConfigurationItem < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  has_many :contact_relations, :dependent => :destroy
  has_many :contacts, :through => :contact_relations

  validates_presence_of :item

  before_validation :update_identifier!

  scope :by_item_type, proc {|type| where(:item_type => type) }
  default_scope order('item_type, identifier')

  def self.generate_ci_for(record)
    raise "Not a real CI object" unless record.respond_to?(:configuration_item)
    ci = ConfigurationItem.find_or_create_by_item_type_and_item_id(record.class.to_s, record.id)
    ci.save
  end

  def update_identifier!
    if self.item.present?
      self.identifier = "#{self.item_type.downcase}::#{self.item.to_s.try(:parameterize)}"
    end
  end

  def self.real_object_classes
    ConfigurationItemsObserver.instance.observed_classes.map(&:name)
  end
end
