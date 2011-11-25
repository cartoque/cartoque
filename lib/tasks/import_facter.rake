desc "Imports cron jobs from tomcats' csv files"
namespace :import do
  task :facter => :environment do
    Settler.load!
    dns_domains_setting = Settler.dns_domains
    dns_domains_values = dns_domains_setting.value.to_s.split(/\n|,/).map(&:strip)
    existing_operating_systems = OperatingSystem.all
    Dir.glob("data/system/*.yml").each do |file|
      #server
      server_name = file.split("/").last.gsub(/\.yml$/,"")
      puts "Updating facts for #{server_name}" if ENV['DEBUG'].present?
      server = Server.find_or_generate(server_name)
      puts "Successfully created Server: #{server.name}" if server.just_created
      #facts
      facts = YAML.load_file(file)
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
        system = nil
        candidates = existing_operating_systems
        candidates.select!{|sys| "#{sys.name}".start_with?(facts["operatingsystem"]) }
        candidates.reject!{|sys| sys.name == facts["operatingsystem"] }
        candidates.select!{|sys| os.start_with?(sys.name) }
        server.operating_system = candidates.first if candidates.count == 1
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
      #save server
      server.save if server.changed?
      #dns domains
      if dns_domains_setting.present? && facts["domain"].present? && !dns_domains_values.include?(facts["domain"])
        dns_domains_setting.value = (dns_domains_values << facts["domain"]).join("\n")
        dns_domains_setting.save
      end
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
