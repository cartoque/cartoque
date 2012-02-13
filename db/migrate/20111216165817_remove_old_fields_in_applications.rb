class RemoveOldFieldsInApplications < ActiveRecord::Migration
  def up
    remove_column :applications, :iaw
    remove_column :applications, :pe
    remove_column :applications, :ams
  end

  def down
    add_column :applications, :iaw, :string, limit: 55, default: "", null: false
    add_column :applications, :pe, :string, limit: 55, default: "", null: false
    add_column :applications, :ams, :string, limit: 55, default: "", null: false
  end
end
