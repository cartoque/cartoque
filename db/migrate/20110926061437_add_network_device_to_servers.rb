class AddNetworkDeviceToServers < ActiveRecord::Migration
  def change
    add_column :servers, :network_device, :boolean
  end
end
