# temp class for active_record versions of objects
class ARNssDisk < ActiveRecord::Base
  self.table_name = "nss_disks"
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigrateNssDisksToMongoid < ActiveRecord::Migration
  def up
    NssDisk.destroy_all
    cols = ARNssDisk.column_names - %w(id)
    ARNssDisk.all.each do |nss_disk|
      attrs = nss_disk.attributes.slice(*cols)
      server_id = attrs.delete("server_id")
      server_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{server_id.to_i};").to_a.flatten.first
      if server_mongo_id.present?
        attrs["server_id"] = server_mongo_id
        NssDisk.create(attrs)
      else
        $stderr.puts "Unable to find server mongo_id with id = #{server_id} ; #{nss_disk.inspect}"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
