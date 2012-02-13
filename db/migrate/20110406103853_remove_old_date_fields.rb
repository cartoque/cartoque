class RemoveOldDateFields < ActiveRecord::Migration
  def self.up
    remove_column :machines, :fin_garantie
    remove_column :machines, :date_mes
  end

  def self.down
    add_column :machines, :fin_garantie, :string, limit: 100, default: "", null: false
    add_column :machines, :date_mes, :string, limit: 100, default: "", null: false
  end
end
