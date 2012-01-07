class MailingList < ActiveRecord::Base
  has_and_belongs_to_many :contacts

  validates_presence_of :name
end
