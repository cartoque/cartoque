desc "Cleanup facts from puppet's yaml files (only ips for now)"
namespace :cleanup do
  task :facter => :environment do
    Dir.glob("data/system/*.yml").each do |file|
      #facts
      facts = YAML.load_file(file)
      #collect IPs found by puppet
      addresses = facts.keys.grep(/^ipaddress_/).map do |key|
        facts[key]
      end
      #destroy old IPs
      Ipaddress.find_by_server_id(server.id).all.each do |addr|
        addr.destroy if !addr.address.in?(addresses)
      end
    end
  end
end
