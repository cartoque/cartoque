class AddDatabaseTypeToDatabases < ActiveRecord::Migration
  def self.up
    add_column :databases, :database_type, :string
  end

  def self.down
    remove_column :databases, :database_type
  end
end
