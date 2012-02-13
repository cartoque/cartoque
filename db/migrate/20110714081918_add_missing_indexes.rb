class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :application_instances, :application_id
    add_index :application_instances_machines, :application_instance_id, name: 'index_appinstances_machines_on_appinstance'
    add_index :application_instances_machines, :machine_id
    add_index :application_urls, :application_instance_id
    add_index :applications_machines, :machine_id
    add_index :applications_machines, :application_id
    add_index :ipaddresses, :machine_id
    add_index :machines, :theme_id
    add_index :machines, :service_id
    add_index :machines, :operating_system_id
    add_index :machines, :physical_rack_id
    add_index :machines, :media_drive_id
    add_index :machines, :mainteneur_id
    add_index :machines, :database_id
    add_index :physical_racks, :site_id
    add_index :storages, :machine_id
  end

  def self.down
    remove_index :storages, :machine_id
    remove_index :physical_racks, :site_id
    remove_index :machines, :database_id
    remove_index :machines, :mainteneur_id
    remove_index :machines, :media_drive_id
    remove_index :machines, :physical_rack_id
    remove_index :machines, :operating_system_id
    remove_index :machines, :service_id
    remove_index :machines, :theme_id
    remove_index :ipaddresses, :machine_id
    remove_index :applications_machines, :application_id
    remove_index :applications_machines, :machine_id
    remove_index :application_urls, :application_instance_id
    remove_index :application_instances_machines, :machine_id
    remove_index :application_instances_machines, :application_instance_id
    remove_index :application_instances, :application_id
  end
end
