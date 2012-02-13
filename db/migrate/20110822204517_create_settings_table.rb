class CreateSettingsTable < ActiveRecord::Migration
  def self.up
    create_table :settings, force: true do |t|
      t.string  :key, null: false
      t.string  :alt
      t.text    :value
      t.boolean :editable
      t.boolean :deletable
      t.boolean :deleted      
      t.timestamps
    end
    
    add_index :settings, :key
  end

  def self.down
    drop_table :settings
  end
end
