class NormalizeApplicationsMachinesAssociation < ActiveRecord::Migration
  def self.up
    remove_column :machines_applications, :id
    rename_table :machines_applications, :applications_machines
  end

  def self.down
    rename_table :applications_machines, :machines_applications
    add_column :machines_applications, :id, :primary_key
  end
end
