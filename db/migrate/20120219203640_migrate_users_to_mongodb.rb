# some useful helpers
require 'ar2mongoid'

# temp class for active_record versions of objects
class ARUser < ActiveRecord::Base
  set_table_name "users"
  serialize :settings
end

# migration!
class MigrateUsersToMongodb < ActiveRecord::Migration
  def up
    add_column :backup_exceptions, :user_mongo_id, :string
    add_column :upgrades, :upgrader_mongo_id, :string
    #migrate sites
    cols = ARUser.column_names - %w(id reset_password_token reset_password_sent_at remember_created_at)
    ARUser.all.each do |user|
      attrs = user.attributes.slice(*cols)
      attrs["settings"] ||= {}
      muser = User.create(attrs)
      ActiveRecord::Base.connection.execute("UPDATE backup_exceptions SET user_mongo_id='#{muser.id}' WHERE user_id = #{user.id}")
      ActiveRecord::Base.connection.execute("UPDATE upgrades SET upgrader_mongo_id='#{muser.id}' WHERE upgrader_id = #{user.id}")
    end
  end

  def down
    #nothing for now! maybe a bit of cleanup later?
    remove_column :upgrades, :upgrader_mongo_id
    remove_column :backup_exceptions, :user_mongo_id
  end
end
