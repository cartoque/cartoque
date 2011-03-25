class CreateDatabases < ActiveRecord::Migration
  def self.up
    create_table :databases do |t|
      t.string :name
      t.timestamps
    end
    add_column :machines, :database_id, :integer
  end

  def self.down
    drop_table :databases
    remove_column :machines, :database_id
  end
end
