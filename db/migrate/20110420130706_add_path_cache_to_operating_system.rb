class AddPathCacheToOperatingSystem < ActiveRecord::Migration
  def self.up
    add_column :operating_systems, :path_cache, :string
    OperatingSystem.reset_column_information
    OperatingSystem.all.each(&:save)
  end

  def self.down
    remove_column :operating_systems, :path_cache
  end
end
