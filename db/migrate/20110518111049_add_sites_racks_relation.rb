class AddSitesRacksRelation < ActiveRecord::Migration
  def self.up
    add_column :physical_racks, :site_id, :integer
    PhysicalRack.all.each do |rack|
      rack.update_attribute :site_id, rack.machines.map(&:site_id).compact.first
    end
    remove_column :machines, :site_id
  end

  def self.down
    add_column :machines, :site_id, :integer
    remove_column :physical_racks, :site_id
  end
end
