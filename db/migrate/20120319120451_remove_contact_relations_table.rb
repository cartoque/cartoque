class RemoveContactRelationsTable < ActiveRecord::Migration
  def up
    drop_table "contact_relations"
  end

  def down
    create_table "contact_relations", :force => true do |t|
      t.integer "configuration_item_id", :default => 0, :null => false
      t.integer "contact_id",            :default => 0, :null => false
      t.integer "role_id"
    end
  end
end
