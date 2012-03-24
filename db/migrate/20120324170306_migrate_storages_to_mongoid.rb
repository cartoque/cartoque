# temp class for active_record versions of objects
class ARStorage < ActiveRecord::Base
  self.table_name = "storages"
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigrateStoragesToMongoid < ActiveRecord::Migration
  def up
    Storage.destroy_all
    cols = ARStorage.column_names - %w(id)
    ARStorage.all.each do |storage|
      attrs = storage.attributes.slice(*cols)
      server_id = attrs.delete("server_id")
      server_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{server_id.to_i};").to_a.flatten.first
      if server_mongo_id.present?
        attrs["server_id"] = server_mongo_id
        Storage.create(attrs)
      else
        $stderr.puts "Unable to find server mongo_id with id = #{server_id} ; #{storage.inspect}"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
