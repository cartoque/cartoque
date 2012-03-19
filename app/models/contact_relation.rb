class ContactRelation < ActiveRecord::Base
  #TODO:
  #belongs_to :configuration_item
  belongs_to :contact
  belongs_to :role
end
