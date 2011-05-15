class RemoveActorsFromApplications < ActiveRecord::Migration
  def self.up
    remove_column :applications, :moa
    remove_column :applications, :amoa
    remove_column :applications, :moa_note
    remove_column :applications, :contact
    remove_column :applications, :pnd
  end

  def self.down
    add_column :applications, :moa, :string
    add_column :applications, :amoa, :string
    add_column :applications, :moa_note, :string
    add_column :applications, :contact, :string
    add_column :applications, :pnd, :string
  end
end
