desc "Imports every assets from files in data/*"
namespace :import do
  task :all => [:cronjobs, :nss_volumes]
end
