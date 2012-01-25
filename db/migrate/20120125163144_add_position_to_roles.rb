class AddPositionToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :position, :integer
  end
end
