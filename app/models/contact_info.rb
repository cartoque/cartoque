class ContactInfo < ActiveRecord::Base
  belongs_to :contact

  validates_presence_of :contact, :info_type, :value
end
