desc "Imports every assets from files in data/*"
namespace :cartoque do
  task :seed => :environment do
    #create a first user if none
    User.create!(name: "admin", email: "admin@example.net", password: "admin") if User.count == 0
  end
end
