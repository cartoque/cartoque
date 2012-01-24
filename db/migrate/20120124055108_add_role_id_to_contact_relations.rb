class AddRoleIdToContactRelations < ActiveRecord::Migration
  def change
    add_column :contact_relations, :role_id, :integer
  end
end
