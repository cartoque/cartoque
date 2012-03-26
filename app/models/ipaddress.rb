class Ipaddress
  include Mongoid::Document
  include Mongoid::Timestamps
  include Acts::Ipaddress

  field :address, type: Integer
  field :comment, type: String
  field :main, type: Boolean
  field :virtual, type: Boolean
  field :macaddress, type: String
  field :netmask, type: String
  field :interface, type: String 
  belongs_to :server, class_name: 'MongoServer'
  acts_as_ipaddress :address

  validates_presence_of :server

  def to_s
    return "" if address.blank?
    html = address
    html << " (vip)" if virtual?
    html = %(<strong>#{html}</strong>) if main?
    html.html_safe
  end
end
