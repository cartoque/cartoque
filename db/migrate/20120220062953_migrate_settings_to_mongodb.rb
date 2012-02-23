# temp class for active_record versions of objects
class ARSetting < ActiveRecord::Base
  set_table_name "settings"
  serialize :value
end

# temp class for mongoid version of setting, without the singleton hassle
class MongoSetting
  include Mongoid::Document
  store_in :settings
  field :cas_server, type: String, default: 'http://localhost:9292'
  field :site_announcement_message, type: String
  field :site_announcement_type, type: String
  field :site_announcement_updated_at, type: DateTime
  field :redmine_url, type: String, default: ''
  field :dns_domains, type: String, default: ''
  field :allow_internal_authentication, type: String, default: 'yes'
end

# migration!
class MigrateSettingsToMongodb < ActiveRecord::Migration
  def up
    MongoSetting.destroy_all
    mongo_setting = MongoSetting.new
    ar_settings = ARSetting.all.inject({}) do |memo, setting|
      memo[setting.key] = setting.value
      memo["site_announcement_updated_at"] = setting.updated_at if setting.key == "site_announcement_message"
      memo
    end
    MongoSetting.fields.keys.each do |key|
      mongo_setting[key] = ar_settings[key] if ar_settings.has_key?(key)
    end
    mongo_setting.save!
  end

  def down
    #nothing for now! maybe a bit of cleanup later?
  end
end
