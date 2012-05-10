class MailingList
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :comment, type: String
  has_and_belongs_to_many :contacts
  has_and_belongs_to_many :companies

  validates_presence_of :name

  def contactables
    contacts + companies
  end

  def email_addresses
    contactables.map(&:email_infos).map(&:first).map(&:value)
  end
end
