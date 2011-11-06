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
          sections[hostname] = attributes if hostname
          hostname = $1
          attributes = {:catalog => catalog, :type => $2, :files => []}
        elsif line.match(/Version logicielle : (.*)/)
          attributes[:client_version] = $1
        elsif line.match(%r{^\s{2,}(/\S*)})
          attributes[:files] << $1
        end
      end
      sections[hostname] = attributes if hostname
    end
    #save data in the db
    sections.each do |servername, attributes|
      server = Server.find_or_generate(servername)
      attributes[:files].each do |fs|
        job = BackupJob.find_or_create_by_server_id_and_hierarchy(server.id, fs)
        job.client_type = "TiNa"
        job.client_version = attributes[:client_version]
        job.catalog = attributes[:catalog]
        job.save if job.changed?
      end
    end
  end
end
