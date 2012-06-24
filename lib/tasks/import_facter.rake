desc "Imports cron jobs from tomcats' csv files"
namespace :import do
  task :facter => :environment do
    dns_domains = Setting.dns_domains.split(/\n|,/).map(&:strip)
    existing_operating_systems = OperatingSystem.all
    Dir.glob("data/system/*.yml").each do |file|
      #server
      server_name = file.split("/").last.gsub(/\.yml$/,"")
      puts "Updating facts for #{server_name}" if ENV['DEBUG'].present?
      server = Server.find_or_generate(server_name)
      puts "Successfully created Server: #{server.name}" if server.just_created
      #facts
      facts = YAML.load_file(file)
      next unless facts
      #update version facts in server
      %w(rubyversion facterversion puppetversion).each do |key|
        server.send("#{key}=", facts[key]) if facts.has_key?(key)
      end
      #operating system
      os = "#{facts["operatingsystem"]} #{facts["operatingsystemrelease"]}"
      if os.present?
        #facter field
        server.operatingsystemrelease = os
        #real os defined in the app
        #TODO: document it !!!
        candidates = existing_operating_systems.dup
        candidates.select!{|sys| "#{sys.name}".start_with?(facts["operatingsystem"]) }
        candidates.reject!{|sys| sys.name == facts["operatingsystem"] }
        candidates.select!{|sys| os.start_with?(sys.name) }
        server.operating_system_id = candidates.first.id if candidates.count == 1
      end
      #virtual or not ?
      if facts["virtual"].present?
        server.virtual = facts["virtual"].in?(%w(vmware xenu kvm))
        server.is_hypervisor = true if facts["virtual"] == "vmware_server"
      end
      #physical machines
      unless server.virtual?
        #serial number
        server.serial_number = facts["serialnumber"] if facts["serialnumber"].present?
        #manufacturer/model
        server.manufacturer = facts["manufacturer"].gsub(/,?\s*Inc\.?$/,"") if facts["manufacturer"].present?
        server.model = facts["productname"] if facts["productname"].present?
      end
      #hardware
      server.arch = facts["hardwaremodel"] if facts["hardwaremodel"].present?
      #processor
      if facts["processorcount"].present?
        system   = facts["processorcountreal"].presence || facts["processorcount"]
        system   = "1" if system.to_i == 0
        physical = facts["physicalprocessorcountreal"].presence || facts["physicalprocessorcount"]
        physical ||= system
        physical = "1" if physical.to_i == 0
        server.processor_physical_count = physical.to_i
        server.processor_system_count   = system.to_i
        server.processor_cores_per_cpu  = server.processor_system_count / server.processor_physical_count
        server.processor_reference      = facts["processor0"].split("@").first.strip.gsub(/\s+/, ' ').gsub(/ CPU /, ' ').gsub('(R)', '')
        server.processor_frequency_GHz  = facts["processor0"].split("@").last.gsub('GHz', '').strip.to_f
      end
      #memory
      if facts["memorysize"].present?
        memory = facts["memoryreal"].presence || facts["memorysize"]
        if memory.match /GB$/
          server.memory_GB = memory.to_f
        elsif memory.match /MB$/
          server.memory_GB = memory.to_f / 1024
        else
          puts "Unable to parse memory for #{server.name}: memorysize=#{facts["memorysize"]}, memoryreal=#{facts["memoryreal"]}" if ENV['DEBUG'].present?
        end
      end
      #save server
      server.save if server.changed?
      #dns domains
      if facts["domain"].present? && !dns_domains.include?(facts["domain"])
        dns_domains << facts["domain"]
        Setting.dns_domains=(dns_domains)
      end
      #update IPs
      facts.keys.grep(/^ipaddress_/).each do |key|
        iface_key = key.gsub(/^ipaddress_/,"")
        addr = facts[key]
        next if iface_key == "lo" && addr == "127.0.0.1"
        ip = Ipaddress.find_or_initialize_by(address: IPAddr.new(addr).to_i, server_id: server.id)
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
