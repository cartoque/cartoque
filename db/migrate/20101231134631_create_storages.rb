class CreateStorages < ActiveRecord::Migration
  def self.up
    create_table :storages do |t|
      t.integer :machine_id
      t.string :file
      t.string :constructor
      t.text :details
      t.timestamps
    end
  end

  def self.down
    drop_table :storages
  end
end
