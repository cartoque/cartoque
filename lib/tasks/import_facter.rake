desc "Imports cron jobs from tomcats' csv files"
namespace :import do
  task :facter => :environment do
    Dir.glob("data/system/*.yml").each do |file|
      #server
      server_name = file.split("/").last.gsub(/\.yml$/,"")
      puts "Updating facts for #{server_name}" if ENV['DEBUG'].present?
      server = Server.find_or_generate(server_name)
      puts "Successfully created Server: #{server.name}" if server.just_created
      #facts
      facts = YAML.load_file(file)
      #update facts in server
      %w(rubyversion facterversion puppetversion).each do |key|
        server.send("#{key}=", facts[key]) if facts.has_key?(key)
      end
      os = "#{facts["operatingsystem"]} #{facts["operatingsystemrelease"]}"
      server.operatingsystemrelease = os if os.present?
      server.save if server.changed?
      #update IPs
      facts.keys.grep(/^ipaddress_/).each do |key|
        iface_key = key.gsub(/^ipaddress_/,"")
        addr = facts[key]
        ip = Ipaddress.find_by_address_and_server_id(IPAddr.new(addr).to_i, server.id) ||
               Ipaddress.new(:address => addr, :server_id => server.id)
        ip.main = (addr == facts["ipaddress"])
        ip.interface = iface_key.gsub("_",":")
        ip.netmask = facts["netmask_#{iface_key}"]
        ip.macaddress = facts["macaddress_#{iface_key}"]
        if ip.changed?
          puts "Updating IP=#{addr} for Server #{server}" if ENV['DEBUG'].present?
          ip.save
        end
      end
    end
  end
end
