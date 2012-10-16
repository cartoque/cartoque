namespace :db do
  desc "Verify all denormalizations and repair any inconsistencies"
  task :denormalize => :environment do
    [ApplicationInstance, PhysicalRack, Server, Tomcat, Cronjob].each do |klass|
      klass.all.each do |item|
        item.force_denormalization = true
        item.save
      end
    end
  end
end
