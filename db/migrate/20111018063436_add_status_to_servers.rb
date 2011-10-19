class AddStatusToServers < ActiveRecord::Migration
  def change
    add_column :servers, :status, :integer, :default => 1
  end
end
