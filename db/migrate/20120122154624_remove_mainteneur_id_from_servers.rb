class RemoveMainteneurIdFromServers < ActiveRecord::Migration
  def up
    remove_column :servers, :mainteneur_id
  end

  def down
    add_column :servers, :mainteneur_id, :integer
  end
end
