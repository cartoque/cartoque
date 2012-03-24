# temp class for active_record versions of objects
class ARNetworkDisk < ActiveRecord::Base
  self.table_name = "network_disks"
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigrateNetworkDisksToMongoid < ActiveRecord::Migration
  def up
    NetworkDisk.destroy_all
    cols = ARNetworkDisk.column_names - %w(id)
    ARNetworkDisk.all.each do |network_disk|
      attrs = network_disk.attributes.slice(*cols)
      server_id = attrs.delete("server_id")
      server_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{server_id.to_i};").to_a.flatten.first
      client_id = attrs.delete("client_id")
      client_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{client_id.to_i};").to_a.flatten.first
      if server_mongo_id.present? && client_mongo_id.present?
        attrs["server_id"] = server_mongo_id
        attrs["client_id"] = client_mongo_id
        NetworkDisk.create(attrs)
      else
        $stderr.puts "Unable to find client and server: client_id='#{client_id}'->'#{client_mongo_id}', server_id='#{server_id}'->'#{server_mongo_id}'"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
