class ConfigurationItem < ActiveRecord::Base
  belongs_to :item, :polymorphic => true

  validates_presence_of :item

  before_validation :update_identifier!

  def update_identifier!
    if self.item.present?
      self.identifier = "#{self.item_type.downcase}::#{self.item.to_s.parameterize}"
    end
  end
end
