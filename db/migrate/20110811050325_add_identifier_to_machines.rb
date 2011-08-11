class AddIdentifierToMachines < ActiveRecord::Migration
  def self.up
    add_column :machines, :identifier, :string
    Machine.all.each do |m|
      m.update_attribute(:identifier, Machine.identifier_for(m.name))
    end
  end

  def self.down
    remove_column :machines, :identifier
  end
end
