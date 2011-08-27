class AddSitesRacksRelation < ActiveRecord::Migration
  def self.up
    add_column :physical_racks, :site_id, :integer
    remove_column :machines, :site_id
  end

  def self.down
    add_column :machines, :site_id, :integer
    remove_column :physical_racks, :site_id
  end
end
