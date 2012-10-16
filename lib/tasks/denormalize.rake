namespace :db do
  desc "Verify all denormalizations and repair any inconsistencies"
  task :denormalize => :environment do
    [ApplicationInstance, PhysicalRack, Server, Tomcat, Cronjob].each do |klass|
      puts "Denormalizing #{klass}'s (#{klass.count})" if ENV['DEBUG'].present?
      klass.all.each do |item|
        print "." if ENV['DEBUG'].present?
        item.force_denormalization = true
        item.save
      end
      puts if ENV['DEBUG'].present?
    end
  end
end
