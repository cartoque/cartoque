class CreateContactRelations < ActiveRecord::Migration
  def change
    create_table :contact_relations do |t|
      t.integer :configuration_item_id, default: 0, null: false
      t.integer :contact_id,            default: 0, null: false
    end
  end
end
