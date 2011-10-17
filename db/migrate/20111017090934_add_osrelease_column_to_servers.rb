class AddOsreleaseColumnToServers < ActiveRecord::Migration
  def change
    add_column :servers, :operatingsystemrelease, :string
  end
end
