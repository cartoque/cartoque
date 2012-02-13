class AddLicensesServers < ActiveRecord::Migration
  def change
    create_table "licenses_servers", id: false do |t|
      t.integer "license_id"
      t.integer "server_id"
    end
  end
end
