# temp class for active_record versions of objects
class ARCronjob < ActiveRecord::Base
  self.table_name = "cronjobs"
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigrateCronjobsToMongoid < ActiveRecord::Migration
  def up
    Cronjob.destroy_all
    cols = ARCronjob.column_names - %w(id)
    ARCronjob.all.each do |job|
      attrs = job.attributes.slice(*cols)
      server_id = attrs.delete("server_id")
      server_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{server_id.to_i};").to_a.flatten.first
      if server_mongo_id.present?
        attrs["server_id"] = server_mongo_id
        Cronjob.create(attrs)
      else
        $stderr.puts "Unable to find server mongo_id with id = #{server_id}"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
