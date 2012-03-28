desc "Imports vmware vms and hosts from json files"
namespace :import do
  task :vmware => :environment do
    #vms/hosts
    Dir.glob("data/vmware/*.json").each do |file|
      host = Server.find_or_generate(file.split("/").last.gsub(/\.json$/, ""))
      host.is_hypervisor = true
      json = JSON.load(File.read(file)) rescue nil
      next if json.blank?
      host_name = json["name"]
      host_ref  = json["ref"]
      cluster =   json["cluster"]
      (json["vms"] || []).select do |vmhsh|
        vmhsh["status"] == "poweredOn"
      end.each do |vmhsh|
        vm = Server.find_or_generate(vmhsh["hostname"])
        vm.virtual = true
        vm.hypervisor = host
        vm.save if vm.changed?
      end
    end
    #backups jobs (vms which have a create_snapshot task in the last 8 days)
    if File.exists?("data/vmware/snapshoted_vms.txt")
      File.readlines("data/vmware/snapshoted_vms.txt").each do |servername|
        servername.chomp!
        server = Server.find_or_generate(servername)
        job = BackupJob.find_or_create_by(server_id: server.id, hierarchy: "/")
        job.client_type = "VDR"
        job.save if job.changed?
      end
    end
  end
end
