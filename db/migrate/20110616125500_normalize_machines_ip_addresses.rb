class NormalizeMachinesIpAddresses < ActiveRecord::Migration
  def self.up
    add_column :machines, :ipaddress, :integer, :limit => 8
  end

  def self.down
    remove_column :machines, :ipaddress
  end
end
