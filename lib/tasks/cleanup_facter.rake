desc "Cleanup facts from puppet's yaml files (only ips for now)"
namespace :cleanup do
  task :facter => :environment do
    Dir.glob("data/system/*.yml").each do |file|
      #server
      server_name = file.split("/").last.gsub(/\.yml$/,"")
      server = Server.find_or_generate(server_name)
      #facts
      facts = YAML.load_file(file) rescue nil
      next unless facts
      #collect IPs found by puppet
      addresses = facts.keys.grep(/^ipaddress_/).map do |key|
        facts[key]
      end
      #destroy old IPs
      Ipaddress.where(server_id: server.id).each do |addr|
        addr.destroy if !addr.address.in?(addresses)
      end
    end
  end
end
