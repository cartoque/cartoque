class DetectSgbdFromOldDatabase < ActiveRecord::Migration
  def self.up
    servers = Machine.where("nom like 'sgbd%'")
    servers.map do |s|
      s.nom.gsub(/-\d*$/,"")
    end.uniq.sort.reverse.each do |cluster|
      d = Database.new(:name => cluster)
      d.machines = servers.select{|s| s.nom.starts_with?(cluster)}
      d.database_type = (cluster.match(/m2$|a$/i) ? "postgres" : "oracle")
      d.save
    end
  end

  def self.down
  end
end
