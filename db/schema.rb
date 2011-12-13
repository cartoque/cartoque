# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20111213183422) do

  create_table "application_instances", :force => true do |t|
    t.string   "name"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_method"
  end

  add_index "application_instances", ["application_id"], :name => "index_application_instances_on_application_id"

  create_table "application_instances_servers", :id => false, :force => true do |t|
    t.integer "application_instance_id", :default => 0, :null => false
    t.integer "server_id",               :default => 0, :null => false
  end

  add_index "application_instances_servers", ["application_instance_id"], :name => "index_appinstances_servers_on_appinstance"
  add_index "application_instances_servers", ["server_id"], :name => "index_application_instances_servers_on_machine_id"

  create_table "application_urls", :force => true do |t|
    t.string   "url"
    t.integer  "application_instance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",                  :default => true
  end

  add_index "application_urls", ["application_instance_id"], :name => "index_application_urls_on_application_instance_id"

  create_table "applications", :force => true do |t|
    t.string  "name",                     :default => "",    :null => false
    t.integer "criticity",  :limit => 1,  :default => 3
    t.string  "info",                     :default => ""
    t.string  "iaw",        :limit => 55, :default => "",    :null => false
    t.string  "pe",         :limit => 55, :default => "",    :null => false
    t.string  "ams",        :limit => 55, :default => "",    :null => false
    t.boolean "cerbere",                  :default => false, :null => false
    t.string  "comment",                  :default => "",    :null => false
    t.string  "identifier"
  end

  create_table "backup_exceptions", :force => true do |t|
    t.string   "user_id"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backup_exceptions_servers", :id => false, :force => true do |t|
    t.integer "backup_exception_id"
    t.integer "server_id"
  end

  create_table "backup_jobs", :force => true do |t|
    t.string   "hierarchy"
    t.string   "client_type"
    t.string   "catalog"
    t.integer  "server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "exclusion_patterns"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.string   "image_url",     :default => "building.png"
    t.boolean  "is_maintainer", :default => false
  end

  create_table "configuration_items", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_infos", :force => true do |t|
    t.integer  "entity_id"
    t.string   "info_type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "entity_type"
  end

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_position"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "image_url",    :default => "ceo.png"
  end

  create_table "contacts_mailing_lists", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "mailing_list_id"
  end

  create_table "cronjobs", :force => true do |t|
    t.integer  "server_id"
    t.string   "definition_location"
    t.string   "frequency"
    t.string   "user"
    t.text     "command"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "databases", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "database_type"
  end

  create_table "ipaddresses", :force => true do |t|
    t.integer  "address",    :limit => 8
    t.text     "comment"
    t.integer  "server_id"
    t.boolean  "main"
    t.boolean  "virtual"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "macaddress"
    t.string   "netmask"
    t.string   "interface"
  end

  add_index "ipaddresses", ["server_id"], :name => "index_ipaddresses_on_server_id"

  create_table "licenses", :force => true do |t|
    t.string   "editor"
    t.string   "key"
    t.string   "title"
    t.string   "quantity"
    t.date     "purshased_on"
    t.date     "renewal_on"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "licenses_servers", :id => false, :force => true do |t|
    t.integer "license_id"
    t.integer "server_id"
  end

  create_table "mailing_lists", :force => true do |t|
    t.string   "name"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_drives", :force => true do |t|
    t.string "name", :limit => 50, :default => "", :null => false
  end

  create_table "network_disks", :force => true do |t|
    t.integer  "server_id"
    t.string   "server_directory"
    t.integer  "client_id"
    t.string   "client_mountpoint"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nss_associations", :force => true do |t|
    t.integer  "nss_volume_id"
    t.integer  "server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nss_disks", :force => true do |t|
    t.string   "name"
    t.string   "wwid"
    t.string   "falconstor_type"
    t.integer  "server_id"
    t.string   "owner"
    t.string   "category"
    t.string   "guid"
    t.string   "fsid"
    t.integer  "size",            :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nss_volumes", :force => true do |t|
    t.string   "name"
    t.integer  "server_id"
    t.integer  "size",             :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "snapshot_enabled",              :default => false
    t.boolean  "timemark_enabled",              :default => false
    t.integer  "falconstor_id"
    t.string   "guid"
    t.string   "falconstor_type"
    t.string   "dataset_guid"
  end

  create_table "operating_systems", :force => true do |t|
    t.string  "name",                :limit => 55, :default => "",    :null => false
    t.string  "icon_path",                         :default => "",    :null => false
    t.string  "ancestry"
    t.integer "ancestry_depth",                    :default => 0
    t.boolean "managed_with_puppet",               :default => false
    t.string  "codename"
  end

  add_index "operating_systems", ["ancestry"], :name => "index_operating_systems_on_ancestry"

  create_table "physical_links", :force => true do |t|
    t.integer  "server_id"
    t.string   "server_label"
    t.integer  "switch_id"
    t.string   "switch_label"
    t.string   "link_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "physical_racks", :force => true do |t|
    t.string  "name",    :limit => 50, :default => "", :null => false
    t.integer "site_id"
    t.integer "status",                :default => 1,  :null => false
  end

  add_index "physical_racks", ["site_id"], :name => "index_physical_racks_on_site_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "fullname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", :force => true do |t|
    t.integer "operating_system_id",                   :default => 0
    t.integer "physical_rack_id",                      :default => 0
    t.integer "media_drive_id",                        :default => 0
    t.integer "mainteneur_id",                         :default => 0
    t.string  "name",                   :limit => 150, :default => "",    :null => false
    t.string  "previous_name",                         :default => "",    :null => false
    t.string  "subnet",                 :limit => 23,  :default => "",    :null => false
    t.string  "lastbyte",               :limit => 9,   :default => "",    :null => false
    t.string  "serial_number",          :limit => 100, :default => "",    :null => false
    t.boolean "virtual",                               :default => false, :null => false
    t.string  "description",                           :default => ""
    t.string  "model",                  :limit => 100, :default => "",    :null => false
    t.string  "memory",                 :limit => 50,  :default => "",    :null => false
    t.float   "frequency",                             :default => 0.0,   :null => false
    t.string  "contract_type",          :limit => 100, :default => "",    :null => false
    t.string  "disk_type",              :limit => 50,  :default => "",    :null => false
    t.integer "disk_size",                             :default => 0
    t.string  "manufacturer",           :limit => 50,  :default => "",    :null => false
    t.string  "ref_proc",               :limit => 100, :default => "",    :null => false
    t.string  "server_type",            :limit => 50,  :default => "",    :null => false
    t.integer "nb_proc",                               :default => 0
    t.integer "nb_coeur",                              :default => 0
    t.integer "nb_rj45",                               :default => 0
    t.integer "nb_fc",                                 :default => 0
    t.integer "nb_iscsi",                              :default => 0
    t.string  "disk_type_alt",          :limit => 50,  :default => "",    :null => false
    t.integer "disk_size_alt",                         :default => 0
    t.integer "nb_disk",                               :default => 0
    t.integer "nb_disk_alt",                           :default => 0
    t.integer "database_id"
    t.date    "delivered_on"
    t.date    "maintained_until"
    t.integer "ipaddress",              :limit => 8
    t.boolean "has_drac",                              :default => false
    t.string  "identifier"
    t.boolean "network_device",                        :default => false, :null => false
    t.integer "hypervisor_id"
    t.boolean "is_hypervisor",                         :default => false, :null => false
    t.string  "puppetversion"
    t.string  "facterversion"
    t.string  "rubyversion"
    t.string  "operatingsystemrelease"
    t.integer "status",                                :default => 1
    t.string  "arch"
    t.integer "maintainer_id"
  end

  add_index "servers", ["database_id"], :name => "index_servers_on_database_id"
  add_index "servers", ["mainteneur_id"], :name => "index_servers_on_mainteneur_id"
  add_index "servers", ["media_drive_id"], :name => "index_servers_on_media_drive_id"
  add_index "servers", ["operating_system_id"], :name => "index_servers_on_operating_system_id"
  add_index "servers", ["physical_rack_id"], :name => "index_servers_on_physical_rack_id"

  create_table "settings", :force => true do |t|
    t.string   "key",        :null => false
    t.string   "alt"
    t.text     "value"
    t.boolean  "editable"
    t.boolean  "deletable"
    t.boolean  "deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["key"], :name => "index_settings_on_key"

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
    t.integer  "server_id"
    t.string   "constructor"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storages", ["server_id"], :name => "index_storages_on_server_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "upgrades", :force => true do |t|
    t.integer  "server_id"
    t.text     "packages_list"
    t.string   "strategy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "settings"
    t.string   "authentication_token"
    t.date     "seen_on"
  end

end
