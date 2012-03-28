require 'nokogiri'

desc "Clean up NSS volumes depending on data/nss/* files"
namespace :cleanup do
  task :nss_volumes => :environment do
    #clean nss for existing <machine>/ipstor.conf
    Dir.glob("data/nss/*/ipstor.conf").each do |file|
      server_name = file.split("/")[-2]
      puts "Cleaning NssVolumes for #{server_name}" if ENV['DEBUG'].present?
      server = Server.find_or_generate(server_name)
      if server.blank?
        puts "Skipping Server #{server_name} because it doesn't exist ; you should run 'rake import:nss_volumes' or 'rake import:all' first."
      else
        vols_in_database_ids = NssVolume.where(server_id: server.id).map(&:id)
        Nokogiri::XML.parse(File.read(file)).search("//VirtualDev").each do |dev|
          volume = NssVolume.where(name: dev["name"], server_id: server.id).first
          vols_in_database_ids -= [volume.id] if volume.present?
        end
        if vols_in_database_ids.any?
          puts "Deleting old NssVolume for Server #{server.name}: #{vols_in_database_ids.join(", ")}"
          NssVolume.where(:_id.in => vols_in_database_ids).each(&:destroy)
        end
      end
    end
    #clean nss volumes that don't have a <machine>/ipstor.conf
    Server.where(:_id.in => NssVolume.all.distinct(:server_id)).each do |server|
      unless File.exists?("data/nss/#{server.name}/ipstor.conf")
        puts "Deleting NssVolumes for Server #{server_name} since it doesn't have a data/nss/<server>/ipstor.conf file"
        server.nss_volumes.each(&:destroy)
      end
    end
  end
end
