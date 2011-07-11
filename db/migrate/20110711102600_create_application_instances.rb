class CreateApplicationInstances < ActiveRecord::Migration
  def self.up
    create_table :application_instances do |t|
      t.string :name
      t.integer :application_id
      t.timestamps
    end
  end

  def self.down
    drop_table :application_instances
  end
end
