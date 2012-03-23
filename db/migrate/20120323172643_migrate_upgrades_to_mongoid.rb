# temp class for active_record versions of objects
class ARUpgrade < ActiveRecord::Base
  self.table_name = "upgrades"
  serialize :packages_list
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigrateUpgradesToMongoid < ActiveRecord::Migration
  def up
    Upgrade.destroy_all
    cols = ARUpgrade.column_names - %w(id upgrader_id)
    ARUpgrade.all.each do |upgrade|
      attrs = upgrade.attributes.slice(*cols)
      server_id = attrs.delete("server_id")
      server_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{server_id.to_i};").to_a.flatten.first
      if server_mongo_id.present?
        attrs["server_id"] = server_mongo_id
        attrs["upgrader_id"] = attrs.delete("upgrader_mongo_id")
        Upgrade.create(attrs)
      else
        $stderr.puts "Unable to find server mongo_id with id = #{server_id}"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
