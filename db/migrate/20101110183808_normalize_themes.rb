class NormalizeThemes < ActiveRecord::Migration
  def self.up
    rename_column :themes, :theme_titre, :titre
    Theme.where(:titre => "-").first.destroy
  end

  def self.down
    Theme.create(:titre => "-")
    rename_column :themes, :titre, :theme_titre
  end
end
