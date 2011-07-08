class Ipaddress < ActiveRecord::Base
  belongs_to :machine
  acts_as_ipaddress :address

  def to_s
    address
  end
end
