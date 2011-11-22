class AddStatusToPhysicalRacks < ActiveRecord::Migration
  def change
    add_column :physical_racks, :status, :integer, :null => false, :default => 1
  end
end
