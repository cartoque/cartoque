desc "Imports network disks from /etc/fstab files"
namespace :import do
  task :network_disks => :environment do
    Dir.glob("data/disks/*.fstab").each do |file|
      #client
      client_name = file.split("/").last.gsub(/\.fstab$/,"")
      puts "Updating NetworkDisks for #{client_name}" if ENV['DEBUG'].present?
      client = Server.find_or_generate(client_name)
      puts "Successfully created Server: #{client.name}" if client.just_created
      #network disks
      File.readlines(file).each do |line|
        next if line.match(/^\s*#/) #commented line
        disk, mountpoint = line.strip.split(/\s+/)
        next if disk.blank? || mountpoint.blank? #blank line
        next unless disk.include?(":") #not a net disk
        server_name = disk.split(":").first
        #if ip address
        if server_name.match(/^\d/)
          server = Ipaddress.where(address: IPAddr.new(server_name).to_i).first.try(:server)
        else
        #if clientname
          server = Server.find_or_generate(server_name)
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
