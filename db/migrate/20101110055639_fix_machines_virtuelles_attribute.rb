class FixMachinesVirtuellesAttribute < ActiveRecord::Migration
  def self.up
    rename_column :machines, :memoire_virtuelle, :virtuelle
  end

  def self.down
    rename_column :machines, :virtuelle, :memoire_virtuelle
  end
end
