class AddIdentifierToMachines < ActiveRecord::Migration
  def self.up
    add_column :machines, :identifier, :string
  end

  def self.down
    remove_column :machines, :identifier
  end
end
