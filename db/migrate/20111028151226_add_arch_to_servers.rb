class AddArchToServers < ActiveRecord::Migration
  def change
    add_column :servers, :arch, :string
  end
end
