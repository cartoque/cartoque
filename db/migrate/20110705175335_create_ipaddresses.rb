class CreateIpaddresses < ActiveRecord::Migration
  def self.up
    create_table :ipaddresses do |t|
      t.integer :address
      t.text :comment
      t.integer :machine_id
      t.boolean :main
      t.boolean :virtual
      t.timestamps
    end
  end

  def self.down
    drop_table :ipaddresses
  end
end
