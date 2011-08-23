class NormalizeServices < ActiveRecord::Migration
  def self.up
    rename_column :services, :service_titre, :nom
  end

  def self.down
    rename_column :services, :nom, :service_titre
  end
end
