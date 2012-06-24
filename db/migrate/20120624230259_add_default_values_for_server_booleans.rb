class AddDefaultValuesForServerBooleans < Mongoid::Migration
  def self.up
    Server.where(network_device: nil).update_all(network_device: false)
    Server.where(virtual: nil).update_all(virtual: false)
  end

  def self.down
  end
end
