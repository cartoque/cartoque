class DeleteThemesAndServices < ActiveRecord::Migration
  def self.up
    remove_column "machines", "theme_id"
    drop_table "themes"

    remove_column "machines", "service_id"
    drop_table "services"
  end

  def self.down
    create_table "services", force: true do |t|
      t.string "name", default: "", null: false
    end
    add_column "machines", "service_id", :integer, default: 0
    add_index  "machines", ["service_id"], name: "index_machines_on_service_id"

    create_table "themes", force: true do |t|
      t.string "name", default: "", null: false
    end
    add_column "machines", "theme_id", :integer, default: 0
    add_index  "machines", ["theme_id"], name: "index_machines_on_theme_id"
  end
end
