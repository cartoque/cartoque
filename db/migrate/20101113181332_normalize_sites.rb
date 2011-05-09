class NormalizeSites < ActiveRecord::Migration
  def self.up
    rename_table :site, :sites
    rename_column :sites, :nom_site, :nom
    Site.delete_all(:nom => "--")
  end

  def self.down
    Site.create(:nom => "--")
    rename_column :sites, :nom, :nom_site
    rename_table :sites, :site
  end
end
