# temp class for active_record versions of objects
class ARPhysicalLink < ActiveRecord::Base
  self.table_name = "physical_links"
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigratePhysicalLinksToMongoid < ActiveRecord::Migration
  def up
    PhysicalLink.destroy_all
    cols = ARPhysicalLink.column_names - %w(id)
    ARPhysicalLink.all.each do |physical_link|
      attrs = physical_link.attributes.slice(*cols)
      server_id = attrs.delete("server_id")
      server_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{server_id.to_i};").to_a.flatten.first
      switch_id = attrs.delete("switch_id")
      switch_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{switch_id.to_i};").to_a.flatten.first
      if server_mongo_id.present? && switch_mongo_id.present?
        attrs["server_id"] = server_mongo_id
        attrs["switch_id"] = switch_mongo_id
        PhysicalLink.create(attrs)
      else
        $stderr.puts "Unable to find switch and server: switch_id='#{switch_id}'->'#{switch_mongo_id}', server_id='#{server_id}'->'#{server_mongo_id}'"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
