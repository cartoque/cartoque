class ContactInfo < ActiveRecord::Base
  belongs_to :contact

  validates_presence_of :info_type, :value

  def to_s
    value
  end
end
