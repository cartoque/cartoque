class RemoveLegacyTables < ActiveRecord::Migration
  def self.up
    drop_table "type"
    drop_table "ref_proc"
    drop_table "marque"
    drop_table "machines_sousreseaux"
    drop_table "iscsi"
    drop_table "interfaces"
    drop_table "frequence"
    drop_table "bureaux"
  end

  def self.down
    create_table "bureaux" do |t|
      t.string "bureau_court", default: "", null: false
      t.string "bureau_long",  default: "", null: false
    end

    create_table "frequence" do |t|
      t.decimal "frequence", precision: 50, scale: 0, default: 0, null: false
    end

    create_table "interfaces" do |t|
      t.integer "id_machines",                 default: 0,     null: false
      t.integer "id_sousreseaux",              default: 0,     null: false
      t.string  "quatr_octet",    limit: 9, default: "",    null: false
      t.boolean "virtuelle",                   default: false, null: false
    end

    create_table "iscsi" do |t|
      t.string "iscsi", limit: 50, default: "", null: false
    end

    create_table "machines_sousreseaux" do |t|
      t.integer "id_machines",    default: 0, null: false
      t.integer "id_sousreseaux", default: 0, null: false
    end
  
    create_table "marque" do |t|
      t.string "marque", limit: 100, default: "", null: false
    end

    create_table "ref_proc" do |t|
      t.string "ref_proc", limit: 50, default: "--", null: false
    end

    create_table "type" do |t|
      t.string "type_serveur", limit: 100, default: "", null: false
    end
  end
end
