class StructureProcessorsForServers < Mongoid::Migration
  def self.up
    Server.all.each do |server|
      next unless server.attributes["ref_proc"].present? && server.attributes["nb_proc"].present?
      #old attributes: frequency, nb_proc, nb_coeur, ref_proc
      #new attributes: processor_X, X in : reference, frequency_GHz, system_count, physical_count, cores_count
      server.processor_frequency_GHz  = server.attributes["frequency"]
      server.processor_physical_count = server.attributes["nb_proc"]
      nb_cores = (server.attributes["nb_coeur"].to_i > 0 ? server.attributes["nb_coeur"] : 1)
      server.processor_cores_per_cpu  = nb_cores
      server.processor_system_count   = server.attributes["nb_proc"] * nb_cores
      server.processor_reference      = server.attributes["ref_proc"]
      server.save
      #delete old things
      server.unset("frequency")
      server.unset("nb_proc")
      server.unset("nb_coeur")
      server.unset("ref_proc")
    end
  end

  def self.down
  end
end
