class MailingList
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :comment, type: String
  has_and_belongs_to_many :contacts

  validates_presence_of :name
end
