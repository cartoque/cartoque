require 'ipaddr'

class IPAddr
  def self.valid?(addr)
    begin
      new(addr, Socket::AF_INET)
    rescue ArgumentError
      false
    end
  end

  def self.new_from_int(addr)
    unless addr.blank?
      new(Integer(addr), Socket::AF_INET).to_s rescue nil
    end
  end
end
