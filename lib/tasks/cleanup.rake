desc "Clean up assets depending on missing files in data/*"
namespace :cleanup do
  task :all => [:cronjobs, :nss_volumes, :nss_disks, :network_disks, :tina, :updates, :vmware]
end
