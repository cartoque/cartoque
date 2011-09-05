class CreatePhysicalLinks < ActiveRecord::Migration
  def change
    create_table :physical_links do |t|
      t.integer :server_id
      t.string :server_label
      t.integer :switch_id
      t.string :switch_label
      t.string :link_type
      t.timestamps
    end
  end
end
