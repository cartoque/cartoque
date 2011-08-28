class Ipaddress < ActiveRecord::Base
  belongs_to :server
  acts_as_ipaddress :address

  def to_s
    return "" if address.blank?
    html = address
    html << " (vip)" if virtual?
    html = %(<span style="font-weight:normal;">#{html}</span>) unless main?
    html.html_safe
  end
end
