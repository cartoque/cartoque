class AddSomeDatesToMachines < ActiveRecord::Migration
  def self.up
    add_column :machines, :delivered_on, :date, null: true
    add_column :machines, :maintained_until, :date, null: true
  end

  def self.down
    remove_column :machines, :delivered_on
    remove_column :machines, :maintained_until
  end
end
