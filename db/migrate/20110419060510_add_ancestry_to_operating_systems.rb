class AddAncestryToOperatingSystems < ActiveRecord::Migration
  def self.up
    add_column :operating_systems, :ancestry, :string
    add_column :operating_systems, :ancestry_depth, :integer, default: 0
    add_index :operating_systems, :ancestry
  end

  def self.down
    remove_index :operating_systems, :ancestry
    remove_column :operating_systems, :ancestry_depth
    remove_column :operating_systems, :ancestry
  end
end
