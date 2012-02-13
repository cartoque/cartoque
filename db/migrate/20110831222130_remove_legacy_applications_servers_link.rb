class RemoveLegacyApplicationsServersLink < ActiveRecord::Migration
  def up
    drop_table "applications_servers"
  end

  def down
    create_table "applications_servers", id: false, force: true do |t|
      t.integer "server_id",      default: 0, null: false
      t.integer "application_id", default: 0, null: false
    end
    add_index "applications_servers", ["application_id"], name: "index_applications_servers_on_application_id"
    add_index "applications_servers", ["server_id"], name: "index_applications_servers_on_machine_id"
  end
end
