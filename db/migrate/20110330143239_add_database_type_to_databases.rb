class AddDatabaseTypeToDatabases < ActiveRecord::Migration
  def self.up
    add_column :databases, :database_type, :string
    Database.all.each do |db|
      db.database_type = 'postgres'
      db.save
    end
  end

  def self.down
    remove_column :databases, :database_type
  end
end
