# temp class for active_record versions of objects
class ARDatabase < ActiveRecord::Base
  self.table_name = "databases"
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigrateDatabasesToMongoid < ActiveRecord::Migration
  def up
    Database.destroy_all
    cols = ARDatabase.column_names - %w(id)
    ARDatabase.all.each do |database|
      attrs = database.attributes.slice(*cols)
      server_id = attrs.delete("server_id")
      server_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{server_id.to_i};").to_a.flatten.first
      if server_mongo_id.present?
        attrs["server_id"] = server_mongo_id
        attrs["type"] = attrs.delete("database_type")
        Database.create(attrs)
      else
        $stderr.puts "Unable to find server mongo_id with id = #{server_id}"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
