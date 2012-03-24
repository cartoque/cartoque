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
      server_ids = ActiveRecord::Base.connection.execute("SELECT id FROM servers WHERE database_id = #{database.id};").to_a.flatten
      server_mongo_ids = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id IN (#{server_ids.join(", ")});").to_a.flatten
      if server_mongo_ids.present?
        attrs["server_ids"] = server_mongo_ids
        attrs["type"] = attrs.delete("database_type")
        Database.create(attrs)
      else
        $stderr.puts "Unable to find servers mongo_id with id = #{server_ids}"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
