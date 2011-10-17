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
        eth = key.gsub(/^ipaddress_/,"").gsub("_",":")
        addr = facts[key]
        main = (addr == facts["ipaddress"])
        ip = Ipaddress.find_by_address_and_server_id(IPAddr.new(addr).to_i, server.id)
        ip = Ipaddress.new(:address => addr, :server_id => server.id) unless ip
        ip.main = main
        ip.comment = eth
        if ip.changed?
          puts "Updating IP=#{addr} for Server #{server}" if ENV['DEBUG'].present?
          ip.save
        end
      end
    end
  end
end
