desc "Remove old tina jobs"
namespace :cleanup do
  task :tina => :environment do
    hierarchies = {}
    catalogs = []
    #collect hierarchies
    Dir.glob("data/tina/*.tina.dump").each do |file|
      hostname = nil
      files = []
      catalogs << file.gsub(/.*catalog_/,"").gsub(".tina.dump","")
      File.read(file).each_line do |line|
        if line.match(/^(?:SYSTEME|- Syst\*me)\s+:\s+(\S+)(?:\s+\[(\S+)\])?/)
          if hostname
            hierarchies[hostname] ||= []
            hierarchies[hostname] += files
          end
          hostname = Server.find_or_generate($1).name
          files = []
        elsif line.match(%r{^\s{2,}(/\S*)})
          files << $1
        end
      end
      if hostname
        hierarchies[hostname] ||= []
        hierarchies[hostname] += files
      end
    end
    #compare with existing jobs
    BackupJob.where(client_type: "TiNa").includes(:server).each do |job|
      #don't do anything if catalog file was not present (this doesn't mean the catalog doesn't exist!)
      next unless job.catalog.in?(catalogs)
      #remove job if server doesn't exist in bacjup jobs OR hierarchy is not listed as backuped
      to_remove = false
      to_remove = true if job.server.blank?
      to_remove = true if !job.server.name.in?(hierarchies.keys)
      to_remove = true if job.server.name.in?(hierarchies.keys) && !job.hierarchy.in?(hierarchies[job.server.name])
      if to_remove
        puts "Removing job #{job.hierarchy}@#{job.server.try(:name)}"
        job.destroy
      end
    end
  end
end
