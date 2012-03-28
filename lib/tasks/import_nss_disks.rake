require 'nokogiri'

desc "Imports NSS disks from data/nss/* files"
namespace :import do
  task :nss_disks => :environment do
    Dir.glob("data/nss/*/ipstor.conf").each do |file|
      server_name = file.split("/")[-2]
      puts "Updating NssDisks for #{server_name}" if ENV['DEBUG'].present?
      server = Server.find_or_generate(server_name)
      puts "Successfully created Server: #{server.name}" if server.just_created
      Nokogiri::XML.parse(File.read(file)).search("//PhysicalDev").each do |dev|
        disk = NssDisk.find_or_create_by(name: dev["name"], server_id: server.id)
        disk.wwid = dev["wwid"]
        disk.falconstor_type = dev["type"]
        disk.owner = dev["owner"]
        disk.category = dev["category"]
        disk.guid = dev["guid"]
        disk.fsid = dev["fsid"]
        disk_geometries = dev.search("Geometry")
        if disk_geometries.any?
          disk_size = disk_geometries.inject(0) do |memo,geom|
            memo += geom["sectorSize"].to_i * (geom["endingSector"].to_i - geom["startingSector"].to_i)
          end
          disk.size = disk_size
        end
        disk.save
      end
    end
  end
end
