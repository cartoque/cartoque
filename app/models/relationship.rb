class Relationship
  include Mongoid::Document

  belongs_to :item, polymorphic: true
  belongs_to :role
  has_and_belongs_to_many :contacts
end
