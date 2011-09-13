require 'nokogiri'

desc "Imports NSS volumes from data/nss/* files"
namespace :import do
  task :nss_volumes => :environment do
    Dir.glob("data/nss/*/ipstor.conf").each do |file|
      server_name = file.split("/")[-2]
      puts "Updating #{server_name}"
      server = Server.find_or_create_by_name(server_name)
      Nokogiri::XML.parse(File.read(file)).search("//VirtualDev").each do |dev|
        volume = NssVolume.find_or_create_by_name_and_server_id(dev["name"], server.id)
        volume.snapshot_enabled = (dev["snapshotEnabled"] == "true")
        volume.timemark_enabled = (dev["timemarkEnabled"] == "true")
        volume.falconstor_id = dev["id"]
        volume.guid = dev["guid"]
        volume.falconstor_type = dev["type"]
        volume.dataset_guid = dev["datasetGuid"]
        vol_geometries = dev.search("Geometry")
        if vol_geometries.any?
          vol_size = vol_geometries.inject(0) do |memo,geom|
            memo += geom["sectorSize"].to_i * (geom["endingSector"].to_i - geom["startingSector"].to_i)
          end
          volume.size = vol_size
        end
        volume.save
      end
    end
  end
end
