class NormalizeSites < ActiveRecord::Migration
  def self.up
    rename_table :site, :sites
    rename_column :sites, :nom_site, :nom
  end

  def self.down
    rename_column :sites, :nom, :nom_site
    rename_table :sites, :site
  end
end
