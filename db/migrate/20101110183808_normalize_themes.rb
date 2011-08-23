class NormalizeThemes < ActiveRecord::Migration
  def self.up
    rename_column :themes, :theme_titre, :titre
  end

  def self.down
    rename_column :themes, :titre, :theme_titre
  end
end
