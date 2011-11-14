desc "Imports tina policies from data/tina/*.tina.dump config dumps"
namespace :import do
  task :tina => :environment do
    sections = {}
    #collect sections
    Dir.glob("data/tina/*.tina.dump").each do |file|
      catalog = file.gsub(/.*catalog_/,"").gsub(".tina.dump","")
      hostname = nil
      attributes = {}
      File.read(file).each_line do |line|
        if line.match(/^(?:SYSTEME|- Syst\*me)\s+:\s+(\S+)(?:\s+\[(\S+)\])?/)
          if hostname
            sections[hostname] ||= []
            sections[hostname] << attributes
          end
          hostname = $1
          attributes = {:catalog => catalog, :type => $2, :files => []}
        elsif line.match(%r{^\s{2,}(/\S*)})
          attributes[:files] << $1
        end
      end
      if hostname
        sections[hostname] ||= []
        sections[hostname] << attributes
      end
    end
    #save data in the db
    sections.each do |servername, jobs|
      server = Server.find_or_generate(servername)
      jobs.each do |attributes|
        attributes[:files].each do |fs|
          job = BackupJob.find_or_create_by_server_id_and_hierarchy(server.id, fs)
          job.client_type = "TiNa"
          job.catalog = attributes[:catalog]
          job.save if job.changed?
        end
      end
    end
  end
end
