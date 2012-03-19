class RemoveConfigurationItemsTable < ActiveRecord::Migration
  def up
    drop_table "configuration_items"
  end

  def down
    create_table "configuration_items", :force => true do |t|
      t.string   "item_type"
      t.integer  "item_id"
      t.string   "identifier"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
