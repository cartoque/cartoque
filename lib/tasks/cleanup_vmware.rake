desc "Remove VMs that are no longer known in vcenter if their host has a .json file"
namespace :cleanup do
  task :vmware => :environment do
    #first list all vms/hosts (even "poweredOff")
    hosts = []
    vms = []
    Dir.glob("data/vmware/*.json").each do |file|
      hosts << file.split("/").last.gsub(/\.json$/, "")
      json = JSON.load(File.read(file)) rescue nil
      next if json.blank?
      json["vms"].each do |vmhsh|
        vms << vmhsh["hostname"]
      end
    end
    #then compare it to virtual servers
    Server.where(:virtual => true).includes(:hypervisor).each do |vm|
      #don't do anything if we don't know the host
      next if vm.hypervisor.blank?
      #if hypervisor is in "hosts" list and vm is not in "vms", it should be deleted
      if vm.hypervisor.name.in?(hosts) && !vm.name.in?(vms)
        puts "Removing vm #{vm.name} (not in any host file, host was #{vm.hypervisor.name})" if ENV['DEBUG'].present?
        vm.destroy
      end
    end
  end
end
