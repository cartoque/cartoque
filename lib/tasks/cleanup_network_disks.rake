desc "Cleans up network disks from /etc/fstab files"
namespace :cleanup do
  task :network_disks => :environment do
    Dir.glob("data/disks/*.fstab").each do |file|
      #client
      client_name = file.split("/").last.gsub(/\.cron$/,"")
      puts "Cleaning NetworkDisks for #{client_name}" if ENV['DEBUG'].present?
      client = Server.find_by_name(client_name) || Server.find_by_identifier(client_name)
      if client.blank?
        puts "Skipping Server #{client_name} because it doesn't exist ; you should run 'rake import:network_disks' or 'rake import:all' first."
      else
        #network disks
        disks_in_database_ids = NetworkDisk.where(:client_id => client.id).map(&:id)
        File.readlines(file).each do |line|
          next if line.match(/^\s*#/) #commented line
          disk, mountpoint = line.strip.split(/\s+/)
          next if disk.blank? || mountpoint.blank? #blank line
          next unless disk.include?(":") #not a net disk
          attrs = {:client_id => client.id, :server_directory => disk, :client_mountpoint => mountpoint}
          if existing = NetworkDisk.where(attrs).first
            disks_in_database_ids -= [existing.id]
          end
        end
        if disks_in_database_ids.any?
          puts "Deleting old NetworkDisks for client #{client.name}: #{disks_in_database_ids.join(", ")}"
          NetworkDisk.where(:id => disks_in_database_ids).each(&:destroy)
        end
      end
    end
  end
end
