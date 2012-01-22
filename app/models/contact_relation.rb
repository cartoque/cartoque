class ContactRelation < ActiveRecord::Base
  #belongs_to :ci, :class_name => "ConfigurationItem"
  belongs_to :configuration_item
  belongs_to :contact
end
