desc "Imports vmware vms and hosts from json files"
namespace :import do
  task :vmware => :environment do
    Dir.glob("data/vmware/*.json").each do |file|
      host = Server.find_or_generate(file.split("/").last.gsub(/\.json$/, ""))
      host.is_hypervisor = true
      json = JSON.load(File.read(file)) rescue nil
      next if json.blank?
      host_name = json["name"]
      host_ref  = json["ref"]
      cluster =   json["cluster"]
      json["vms"].each do |vmhsh|
        vm = Server.find_or_generate(vmhsh["hostname"])
        vm.virtual = true
        vm.hypervisor = host
        vm.save if vm.changed?
      end
    end
  end
end
