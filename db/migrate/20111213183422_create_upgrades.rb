class CreateUpgrades < ActiveRecord::Migration
  def change
    create_table :upgrades do |t|
      t.integer :server_id
      t.text :packages_list
      t.string :strategy

      t.timestamps
    end
  end
end
