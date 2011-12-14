class AddSomeCountFieldsToUpgrades < ActiveRecord::Migration
  def change
    add_column :upgrades, :count_total, :integer
    add_column :upgrades, :count_needing_reboot, :integer
    add_column :upgrades, :count_important, :integer
  end
end
