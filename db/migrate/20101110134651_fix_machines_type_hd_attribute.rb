class FixMachinesTypeHdAttribute < ActiveRecord::Migration
  def self.up
    rename_column :machines, :type_hd, :type_disque
  end

  def self.down
    rename_column :machines, :type_disque, :type_hd
  end
end
