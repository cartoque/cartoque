class RemoveServerTypeFromServers < ActiveRecord::Migration
  def up
    remove_column :servers, :server_type
  end

  def down
    add_column :servers, :server_type, :string
  end
end
