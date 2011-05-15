class DetectSgbdFromOldDatabase < ActiveRecord::Migration
  def self.up
    servers = Machine.where("nom like 'sgbd%'")
    servers.map do |s|
      s.nom.gsub(/-\d*$/,"")
    end.uniq.sort.reverse.each do |cluster|
      d = Database.find_or_create_by_name(cluster)
      d.update_attribute(:database_type, (cluster.match(/m2$|a$/i) ? "postgres" : "oracle"))
      servers.select{|s| s.nom.starts_with?(cluster)}.each do |server|
        server.update_attribute("database_id", d.id)
      end
    end
  end

  def self.down
  end
end
