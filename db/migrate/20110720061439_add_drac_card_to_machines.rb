class AddDracCardToMachines < ActiveRecord::Migration
  def self.up
    add_column :machines, :has_drac, :boolean, default: false
  end

  def self.down
    remove_column :machines, :has_drac
  end
end
