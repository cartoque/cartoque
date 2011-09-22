class CreateNetworkDisks < ActiveRecord::Migration
  def change
    create_table :network_disks do |t|
      t.integer :server_id
      t.string :server_directory
      t.integer :client_id
      t.string :client_mountpoint
      t.timestamps
    end
  end
end
