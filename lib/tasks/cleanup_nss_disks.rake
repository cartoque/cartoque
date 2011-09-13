require 'nokogiri'

desc "Clean up NSS disks depending on data/nss/* files"
namespace :cleanup do
  task :nss_disks => :environment do
    #clean nss for existing <machine>/ipstor.conf
    Dir.glob("data/nss/*/ipstor.conf").each do |file|
      server_name = file.split("/")[-2]
      puts "Cleaning NssDisks for #{server_name}"
      server = Server.find_by_name(server_name)
      if server.blank?
        puts "Skipping Server #{server_name} because it doesn't exist ; you should run 'rake import:nss_disks' or 'rake import:all' first."
      else
        disks_in_database_ids = NssDisk.where(:server_id => server.id).map(&:id)
        Nokogiri::XML.parse(File.read(file)).search("//PhysicalDev").each do |dev|
          disk = NssDisk.find_by_name_and_server_id(dev["name"], server.id)
          disks_in_database_ids -= [disk.id] if disk.present?
        end
        if disks_in_database_ids.any?
          puts "Deleting old NssDisk for Server #{server.name}: #{disks_in_database_ids.join(", ")}"
          NssDisk.where(:id => disks_in_database_ids).each(&:destroy)
        end
      end
    end
    #clean nss volumes that don't have a <machine>/ipstor.conf
    Server.where(:id => NssDisk.select("distinct(server_id)").map(&:server_id)).each do |server|
      unless File.exists?("data/nss/#{server.name}/ipstor.conf")
        puts "Deleting NssDisks for Server #{server_name} since it doesn't have a data/nss/<server>/ipstor.conf file"
        server.nss_disks.each(&:destroy)
      end
    end
  end
end
