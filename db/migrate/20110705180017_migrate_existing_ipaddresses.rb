class MigrateExistingIpaddresses < ActiveRecord::Migration
  def self.up
    Machine.all.each do |machine|
      if machine.ipaddress
        machine.ipaddresses << Ipaddress.new(:address => machine.ipaddress, :main => true)
        machine.save
      end
    end
  end

  def self.down
    Ipaddress.all.each(&:destroy)
  end
end
