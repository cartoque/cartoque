class RemoveUnusedDatabaseInstanceModel < ActiveRecord::Migration
  def up
    drop_table :database_instances
  end

  def down
    create_table :database_instances do |t|
      t.string :name
      t.string :ipaddress, limit: 8
      t.integer :port
      t.string :database_version
      t.integer :database_id
      t.timestamps
    end
  end
end
