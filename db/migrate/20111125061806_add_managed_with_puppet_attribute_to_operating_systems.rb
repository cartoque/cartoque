class AddManagedWithPuppetAttributeToOperatingSystems < ActiveRecord::Migration
  def change
    add_column :operating_systems, :managed_with_puppet, :boolean, default: false
  end
end
