# temp class for active_record versions of objects
class ARNssVolume < ActiveRecord::Base
  self.table_name = "nss_volumes"
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigrateNssVolumesToMongoid < ActiveRecord::Migration
  def up
    NssVolume.destroy_all
    cols = ARNssVolume.column_names - %w(id)
    ARNssVolume.all.each do |nss_volume|
      attrs = nss_volume.attributes.slice(*cols)
      server_id = attrs.delete("server_id")
      server_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{server_id.to_i};").to_a.flatten.first
      client_ids = ActiveRecord::Base.connection.execute("SELECT server_id FROM nss_associations WHERE nss_volume_id = #{nss_volume.id};").to_a.flatten
      if client_ids.any?
        client_mongo_ids = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id IN (#{client_ids.join(", ")});").to_a.flatten
      else
        client_mongo_ids = []
      end
      if server_mongo_id.present?
        attrs["server_id"] = server_mongo_id
        attrs["client_ids"] = client_mongo_ids
        NssVolume.create(attrs)
      else
        $stderr.puts "Unable to find switch and server: switch_id='#{switch_id}'->'#{switch_mongo_id}', server_id='#{server_id}'->'#{server_mongo_id}'"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
