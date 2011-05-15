class AddPathCacheToOperatingSystem < ActiveRecord::Migration
  def self.up
    add_column :operating_systems, :path_cache, :string
  end

  def self.down
    remove_column :operating_systems, :path_cache
  end
end
