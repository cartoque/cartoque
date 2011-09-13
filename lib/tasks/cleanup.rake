desc "Clean up assets depending on missing files in data/*"
namespace :cleanup do
  task :all => [:cronjobs, :nss_volumes]
end
