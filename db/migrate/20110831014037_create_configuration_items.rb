class CreateConfigurationItems < ActiveRecord::Migration
  def change
    create_table :configuration_items do |t|
      t.string :item_type
      t.integer :item_id
      t.string :identifier
      t.timestamps
    end
  end
end
