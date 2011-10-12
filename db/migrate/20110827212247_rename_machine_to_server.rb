class RenameMachineToServer < ActiveRecord::Migration
  def change
    rename_table "application_instances_machines", "application_instances_servers"
    rename_column "application_instances_servers", "machine_id", "server_id"
    rename_index "application_instances_servers", "index_appinstances_machines_on_appinstance",
                                                  "index_appinstances_servers_on_appinstance"
    rename_index "application_instances_servers", "index_application_instances_machines_on_machine_id",
                                                  "index_application_instances_servers_on_machine_id"

    rename_table "applications_machines", "applications_servers"
    rename_column "applications_servers", "machine_id", "server_id"
    rename_index "applications_servers", "index_applications_machines_on_application_id",
                                         "index_applications_servers_on_application_id"
    rename_index "applications_servers", "index_applications_machines_on_machine_id",
                                         "index_applications_servers_on_machine_id"

    rename_column "ipaddresses", "machine_id", "server_id"
    rename_index "ipaddresses", "index_ipaddresses_on_machine_id", "index_ipaddresses_on_server_id"

    rename_table "machines", "servers"
    rename_index "servers", "index_machines_on_database_id", "index_servers_on_database_id"
    rename_index "servers", "index_machines_on_mainteneur_id", "index_servers_on_mainteneur_id"
    rename_index "servers", "index_machines_on_media_drive_id", "index_servers_on_media_drive_id"
    rename_index "servers", "index_machines_on_operating_system_id", "index_servers_on_operating_system_id"
    rename_index "servers", "index_machines_on_physical_rack_id", "index_servers_on_physical_rack_id"
  
    rename_column "storages", "machine_id", "server_id"
    rename_index "storages", "index_storages_on_machine_id", "index_storages_on_server_id"
  end
end



