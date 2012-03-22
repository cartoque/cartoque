# temp class for active_record versions of objects
class ARServer < ActiveRecord::Base
  self.table_name = "servers"

  def application_instance_ids
    ActiveRecord::Base.connection.execute("SELECT application_instance_mongo_id FROM application_instances_servers WHERE server_id = '#{self.id}';").to_a.flatten
  end

  def license_ids
    ActiveRecord::Base.connection.execute("SELECT license_mongo_id FROM licenses_servers WHERE server_id=#{self.id};").to_a.flatten
  end

  def backup_exception_ids
    ActiveRecord::Base.connection.execute("SELECT backup_exception_mongo_id FROM backup_exceptions_servers WHERE server_id=#{self.id};").to_a.flatten
  end
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigrateServersToMongoid < ActiveRecord::Migration
  def up
    add_column :servers, :mongo_id, :string
    MongoServer.destroy_all
    cols = ARServer.column_names.select{|name| !name.ends_with?("id") || name.ends_with?("mongo_id") }
    ARServer.all.each do |srv|
      attrs = srv.attributes.slice(*cols)
      attrs["ci_identifier"] = attrs.delete("identifier")
      %w(media_drive physical_rack operating_system maintainer).each do |assoc|
        attrs["#{assoc}_id"] = attrs.delete("#{assoc}_mongo_id") if attrs["#{assoc}_mongo_id"].present?
      end
      %w(application_instance license backup_exception).each do |assoc|
        attrs["#{assoc}_ids"] = srv.send("#{assoc}_ids")
      end
      msrv = MongoServer.create(attrs)
      ActiveRecord::Base.connection.execute("UPDATE servers SET mongo_id='#{msrv.id.to_s}' WHERE id = #{srv.id}")
    end
  end

  def down
    remove_column :servers, :mongo_id
    #nothing else for now! maybe a bit of cleanup later?
  end
end
