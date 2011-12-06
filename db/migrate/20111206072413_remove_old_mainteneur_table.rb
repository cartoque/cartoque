class RemoveOldMainteneurTable < ActiveRecord::Migration
  def up
    drop_table "mainteneurs"
  end

  def down
    create_table "mainteneurs" do |t|
      t.string "name",       :limit => 50,  :default => "", :null => false
      t.string "phone",      :limit => 100, :default => "", :null => false
      t.string "email",      :limit => 200, :default => "", :null => false
      t.string "address",    :limit => 200, :default => "", :null => false
      t.string "client_ref", :limit => 50,  :default => "", :null => false
    end
  end
end
