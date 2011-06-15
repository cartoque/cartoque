class RemovePathCacheFromOperatingSystem < ActiveRecord::Migration
  def self.up
    remove_column :operating_systems, :path_cache
  end

  def self.down
    add_column :operating_systems, :path_cache, :string
  end
end
