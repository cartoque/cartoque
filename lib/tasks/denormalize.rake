namespace :db do
  desc "Verify all denormalizations and repair any inconsistencies"
  task :denormalize => :environment do
    errors = []
    denormalized_associations.each do |klass, associations|
      associations.each do |association|
        method = "denormalize_from_#{association}"
        debug "Denormalizing #{klass}##{method}\n"
        klass.all.each do |item|
          begin
            item.send(method)
            item.save
            debug "."
          rescue
            errors << "#{item} (denormalize_from_#{association})"
            debug "F"
          end
        end
        debug "\n"
      end
    end
    debug "\n#{errors.count} errors:\n#{errors.join("\n")}\n"
  end

  def debug(str)
    print str if ENV['DEBUG'].present?
  end

  def denormalized_associations
    {
      ApplicationInstance => %w(application),
      Cronjob             => %w(server),
      PhysicalRack        => %w(site),
      Server              => %w(physical_rack maintainer operating_system),
      Tomcat              => %w(server)
    }
  end
end

