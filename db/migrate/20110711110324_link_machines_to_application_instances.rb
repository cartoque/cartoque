class LinkMachinesToApplicationInstances < ActiveRecord::Migration
  def self.up
    create_table :application_instances_machines, id: false do |t|
      t.integer :application_instance_id, default: 0, null: false
      t.integer :machine_id,              default: 0, null: false
    end
  end

  def self.down
    drop_table :application_instances_machines
  end
end
