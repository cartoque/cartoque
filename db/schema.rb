# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110714081918) do

  create_table "application_instances", :force => true do |t|
    t.string   "name"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_method"
  end

  add_index "application_instances", ["application_id"], :name => "index_application_instances_on_application_id"

  create_table "application_instances_machines", :id => false, :force => true do |t|
    t.integer "application_instance_id", :default => 0, :null => false
    t.integer "machine_id",              :default => 0, :null => false
  end

  add_index "application_instances_machines", ["application_instance_id"], :name => "index_application_instances_machines_on_application_instance_id"
  add_index "application_instances_machines", ["machine_id"], :name => "index_application_instances_machines_on_machine_id"

  create_table "application_urls", :force => true do |t|
    t.string   "url"
    t.integer  "application_instance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "application_urls", ["application_instance_id"], :name => "index_application_urls_on_application_instance_id"

  create_table "applications", :force => true do |t|
    t.string  "name",                     :default => "",    :null => false
    t.integer "criticity",  :limit => 1,  :default => 3
    t.text    "info",                                        :null => false
    t.string  "iaw",        :limit => 55, :default => "",    :null => false
    t.string  "pe",         :limit => 55, :default => "",    :null => false
    t.string  "ams",        :limit => 55, :default => "",    :null => false
    t.boolean "cerbere",                  :default => false, :null => false
    t.string  "comment",                  :default => "",    :null => false
    t.string  "identifier"
  end

  create_table "applications_machines", :id => false, :force => true do |t|
    t.integer "machine_id",     :default => 0, :null => false
    t.integer "application_id", :default => 0, :null => false
  end

  add_index "applications_machines", ["application_id"], :name => "index_applications_machines_on_application_id"
  add_index "applications_machines", ["machine_id"], :name => "index_applications_machines_on_machine_id"

  create_table "bureaux", :force => true do |t|
    t.string "bureau_court", :default => "", :null => false
    t.string "bureau_long",  :default => "", :null => false
  end

  create_table "databases", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "database_type"
  end

  create_table "frequence", :force => true do |t|
    t.decimal "frequence", :precision => 50, :scale => 0, :default => 0, :null => false
  end

  create_table "interfaces", :force => true do |t|
    t.integer "id_machines",                 :default => 0,     :null => false
    t.integer "id_sousreseaux",              :default => 0,     :null => false
    t.string  "quatr_octet",    :limit => 9, :default => "",    :null => false
    t.boolean "virtuelle",                   :default => false, :null => false
  end

  create_table "ipaddresses", :force => true do |t|
    t.integer  "address",    :limit => 8
    t.text     "comment"
    t.integer  "machine_id"
    t.boolean  "main"
    t.boolean  "virtual"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ipaddresses", ["machine_id"], :name => "index_ipaddresses_on_machine_id"

  create_table "iscsi", :force => true do |t|
    t.string "iscsi", :limit => 50, :default => "", :null => false
  end

  create_table "machines", :force => true do |t|
    t.integer "theme_id",                           :default => 0
    t.integer "service_id",                         :default => 0
    t.integer "operating_system_id",                :default => 0
    t.integer "physical_rack_id",                   :default => 0
    t.integer "media_drive_id",                     :default => 0
    t.integer "mainteneur_id",                      :default => 0
    t.string  "name",                :limit => 150, :default => "",    :null => false
    t.string  "previous_name",                      :default => "",    :null => false
    t.string  "subnet",              :limit => 23,  :default => "",    :null => false
    t.string  "lastbyte",            :limit => 9,   :default => "",    :null => false
    t.string  "serial_number",       :limit => 100, :default => "",    :null => false
    t.boolean "virtual",                            :default => false, :null => false
    t.text    "description",                                           :null => false
    t.string  "model",               :limit => 100, :default => "",    :null => false
    t.string  "memory",              :limit => 50,  :default => "",    :null => false
    t.float   "frequency",                          :default => 0.0,   :null => false
    t.string  "contract_type",       :limit => 100, :default => "",    :null => false
    t.string  "disk_type",           :limit => 50,  :default => "",    :null => false
    t.integer "disk_size",                          :default => 0
    t.string  "manufacturer",        :limit => 50,  :default => "",    :null => false
    t.string  "ref_proc",            :limit => 100, :default => "",    :null => false
    t.string  "server_type",         :limit => 50,  :default => "",    :null => false
    t.integer "nb_proc",                            :default => 0
    t.integer "nb_coeur",                           :default => 0
    t.integer "nb_rj45",                            :default => 0
    t.integer "nb_fc",                              :default => 0
    t.integer "nb_iscsi",                           :default => 0
    t.string  "disk_type_alt",       :limit => 50,  :default => "",    :null => false
    t.integer "disk_size_alt",                      :default => 0
    t.integer "nb_disk",                            :default => 0
    t.integer "nb_disk_alt",                        :default => 0
    t.integer "database_id"
    t.date    "delivered_on"
    t.date    "maintained_until"
    t.integer "ipaddress",           :limit => 8
  end

  add_index "machines", ["database_id"], :name => "index_machines_on_database_id"
  add_index "machines", ["mainteneur_id"], :name => "index_machines_on_mainteneur_id"
  add_index "machines", ["media_drive_id"], :name => "index_machines_on_media_drive_id"
  add_index "machines", ["operating_system_id"], :name => "index_machines_on_operating_system_id"
  add_index "machines", ["physical_rack_id"], :name => "index_machines_on_physical_rack_id"
  add_index "machines", ["service_id"], :name => "index_machines_on_service_id"
  add_index "machines", ["theme_id"], :name => "index_machines_on_theme_id"

  create_table "machines_sousreseaux", :force => true do |t|
    t.integer "id_machines",    :default => 0, :null => false
    t.integer "id_sousreseaux", :default => 0, :null => false
  end

  create_table "mainteneurs", :force => true do |t|
    t.string "name",       :limit => 50,  :default => "", :null => false
    t.string "phone",      :limit => 100, :default => "", :null => false
    t.string "email",      :limit => 200, :default => "", :null => false
    t.string "address",    :limit => 200, :default => "", :null => false
    t.string "client_ref", :limit => 50,  :default => "", :null => false
  end

  create_table "marque", :force => true do |t|
    t.string "marque", :limit => 100, :default => "", :null => false
  end

  create_table "media_drives", :force => true do |t|
    t.string "name", :limit => 50, :default => "", :null => false
  end

  create_table "operating_systems", :force => true do |t|
    t.string  "name",           :limit => 55, :default => "", :null => false
    t.string  "icon_path",                    :default => "", :null => false
    t.string  "ancestry"
    t.integer "ancestry_depth",               :default => 0
  end

  add_index "operating_systems", ["ancestry"], :name => "index_operating_systems_on_ancestry"

  create_table "physical_racks", :force => true do |t|
    t.string  "name",    :limit => 50, :default => "", :null => false
    t.integer "site_id"
  end

  add_index "physical_racks", ["site_id"], :name => "index_physical_racks_on_site_id"

  create_table "ref_proc", :force => true do |t|
    t.string "ref_proc", :limit => 50, :default => "--", :null => false
  end

  create_table "services", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "sites", :force => true do |t|
    t.string "name", :limit => 50, :default => "", :null => false
  end

  create_table "sousreseaux", :force => true do |t|
    t.string "cidr_mask",        :limit => 23, :default => "", :null => false
    t.string "name",                           :default => "", :null => false
    t.string "background_color", :limit => 7,  :default => "", :null => false
    t.string "color",            :limit => 7,  :default => "", :null => false
  end

  add_index "sousreseaux", ["cidr_mask"], :name => "sousreseau_ip"

  create_table "storages", :force => true do |t|
    t.integer  "machine_id"
    t.string   "constructor"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storages", ["machine_id"], :name => "index_storages_on_machine_id"

  create_table "themes", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "type", :force => true do |t|
    t.string "type_serveur", :limit => 100, :default => "", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
