class AddJobDoneColumnsToUpgrades < ActiveRecord::Migration
  def change
    add_column :upgrades, :upgraded_status, :boolean, :default => false
    add_column :upgrades, :upgrader_id, :integer
  end
end
