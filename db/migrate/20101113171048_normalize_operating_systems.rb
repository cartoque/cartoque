class NormalizeOperatingSystems < ActiveRecord::Migration
  def self.up
    rename_table :os, :operating_systems
    rename_column :machines, :os_id, :operating_system_id
    rename_column :operating_systems, :os_titre, :nom
    rename_column :operating_systems, :os_img_url, :icon_path
    OperatingSystem.delete_all(:nom => "-")
  end

  def self.down
    rename_column :operating_systems, :icon_path, :os_img_url
    rename_column :operating_systems, :nom, :os_titre
    rename_column :machines, :operating_system_id, :os_id
    rename_table :operating_systems, :os
  end
end
