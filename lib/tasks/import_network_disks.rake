desc "Imports network disks from /etc/fstab files"
namespace :import do
  task :network_disks => :environment do
    Dir.glob("data/disks/*.fstab").each do |file|
      #client
      client_name = file.split("/").last.gsub(/\.cron$/,"")
      puts "Updating NetworkDisks for #{client_name}" if ENV['DEBUG'].present?
      client = Server.find_by_name(client_name) || Server.find_by_identifier(client_name) || Server.create(:name => client_name)
      #network disks
      File.readlines(file).each do |line|
        next if line.match(/^\s*#/) #commented line
        disk, mountpoint = line.strip.split(/\s+/)
        next if disk.blank? || mountpoint.blank? #blank line
        next unless disk.include?(":") #not a net disk
        server_name = disk.split(":").first
        #if ip address
        if server_name.match(/^\d/)
          server = Server.joins(:ipaddresses).where("ipaddresses.address" => IPAddr.new(server_name).to_i).first
        else
        #if clientname
          server = Server.find_by_name(server_name) || Server.find_by_identifier(server_name) || Server.create(:name => server_name)
        end
        if server.blank?
          puts "Warning! couldn't find Server with IP Address #{server_name}"
        else
          attrs = {:server_id => server.id, :client_id => client.id, :server_directory => disk, :client_mountpoint => mountpoint}
          if NetworkDisk.where(attrs).first.blank?
            NetworkDisk.create(attrs)
            puts "Successfully created network disk for client=#{client.name}: #{disk}"
          end
        end
      end
    end
  end
end
