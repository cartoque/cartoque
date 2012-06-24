class CleanupEmptyIpAddresses < Mongoid::Migration
  def self.up
    Ipaddress.where(address: nil).each(&:destroy)
    Server.all.each do |server|
      server.update_main_ipaddress
      server.save
    end
  end

  def self.down
  end
end
