require 'nokogiri'

desc "Imports NSS volumes from data/nss/* files"
namespace :import do
  task :nss_volumes => :environment do
    Dir.glob("data/nss/*/ipstor.conf").each do |file|
      #server
      server_name = file.split("/")[-2]
      puts "Updating NssVolumes for #{server_name}" if ENV['DEBUG'].present?
      server = Server.find_or_generate(server_name)
      puts "Successfully created Server: #{server.name}" if server.just_created
      #xml parsing
      xml = Nokogiri::XML.parse(File.read(file))
      #server associations
      #{volume_id=>[client1,client2,..]}
      clients_index = xml.search("SANClient").inject({}) do |hsh,a|
        a.search("FibreChannelDevice").each do |v|
          #v["vdevname"]
          hsh[v["id"]] ||= []
          hsh[v["id"]] << Server.find_or_create_by(name: a["name"].split(".").first).id.to_s
        end
        hsh
      end
      #nss volume
      xml.search("//VirtualDev").each do |dev|
        volume = NssVolume.find_or_create_by(name: dev["name"], server_id: server.id)
        volume.snapshot_enabled = (dev["snapshotEnabled"] == "true")
        volume.timemark_enabled = (dev["timemarkEnabled"] == "true")
        volume.falconstor_id = dev["id"]
        volume.guid = dev["guid"]
        volume.falconstor_type = dev["type"]
        volume.dataset_guid = dev["datasetGuid"]
        #geometry => size
        vol_geometries = dev.search("Geometry")
        if vol_geometries.any?
          vol_size = vol_geometries.inject(0) do |memo,geom|
            memo += geom["sectorSize"].to_i * (geom["endingSector"].to_i - geom["startingSector"].to_i)
          end
          volume.size = vol_size
        end
        #associated servers
        volume.client_ids = clients_index[dev["id"]] || []
        #save it!
        volume.save
      end
    end
  end
end
