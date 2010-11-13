class MoveSomeFieldsToBooleans < ActiveRecord::Migration
  def self.up
    change_column :machines, :virtuelle, :boolean, :default => false
    change_column :applications, :cerbere, :boolean, :default => false
  end

  def self.down
    change_column :machines, :virtuelle, :integer, :limit => 1, :default => 0, :null => false
    change_column :applications, :cerbere, :integer, :limit => 1, :default => 0, :null => false
  end
end
