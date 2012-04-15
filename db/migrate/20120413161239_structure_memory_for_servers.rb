class StructureMemoryForServers < Mongoid::Migration
  def self.up
    Server.all.each do |server|
      if server.attributes["memory"].present?
        #old attribute: memory (String)
        #new attribute: memory_Gb (Float)
        server.memory_GB = server.attributes["memory"].gsub(",", ".").strip.to_f
        server.save
      end
      #delete old things
      server.unset("memory")
    end
  end

  def self.down
  end
end
