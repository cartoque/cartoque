class ContactRelation < ActiveRecord::Base
  belongs_to :configuration_item
  belongs_to :contact
  belongs_to :role
end
