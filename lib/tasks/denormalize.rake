namespace :db do
  desc "Verify all denormalizations and repair any inconsistencies"
  task :denormalize => :environment do
    #standard models
    [PhysicalRack, Server, Tomcat].each do |klass|
      puts "Denormalizing #{klass}'s (#{klass.count})" if ENV['DEBUG'].present?
      klass.all.each do |item|
        denormalize_item(item)
      end
      puts if ENV['DEBUG'].present?
    end if false
    #complex ones
    puts "Denormalizing ApplicationInstance's (#{Application.count} Applications)" if ENV['DEBUG'].present?
    Application.all.each do |item|
      instance = item.application_instances.first
      denormalize_item(instance) unless instance.nil?
    end
  end

  def denormalize_item(item)
    begin
      print "." if ENV['DEBUG'].present?
      item.force_denormalization = true
      item.save
    rescue
      puts "\nproblem with #{item}"
    end
  end
end
