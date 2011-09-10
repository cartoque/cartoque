desc "Imports every assets from files in data/*"
namespace :import do
  task :all => [:cronjobs]
end
