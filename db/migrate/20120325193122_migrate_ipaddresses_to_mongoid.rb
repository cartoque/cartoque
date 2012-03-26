# temp class for active_record versions of objects
class ARIpaddress < ActiveRecord::Base
  self.table_name = "ipaddresses"
end

#the MongoServer class will be renamed Server after the migration
begin; MongoServer; rescue NameError; MongoServer = Server; end

# migration!
class MigrateIpaddressesToMongoid < ActiveRecord::Migration
  def up
    Ipaddress.destroy_all
    cols = ARIpaddress.column_names - %w(id ipaddressr_id)
    ARIpaddress.all.each do |ipaddress|
      attrs = ipaddress.attributes.slice(*cols)
      server_id = attrs.delete("server_id")
      server_mongo_id = ActiveRecord::Base.connection.execute("SELECT mongo_id FROM servers WHERE id = #{server_id.to_i};").to_a.flatten.first
      server = MongoServer.find(server_mongo_id) rescue nil
      if server.present?
        attrs["server_id"] = server_mongo_id
        ip = Ipaddress.new(attrs)
        #special trick to avoid address interpretation by acts_as_ipaddress
        ip.write_attribute(:address, ipaddress.read_attribute(:address))
        ip.save
        #touch server so that its main address gets updated
        server.save
      else
        $stderr.puts "Unable to find server mongo_id with id = #{server_id}"
      end
    end
  end

  def down
    #nothing else for now! maybe a bit of cleanup later?
  end
end
