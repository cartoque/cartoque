class ContactInfo < ActiveRecord::Base
  belongs_to :entity, polymorphic: true

  validates_presence_of :info_type, :value

  def to_s
    value
  end
end
