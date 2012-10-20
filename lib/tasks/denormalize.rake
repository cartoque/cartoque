namespace :db do
  desc "Verify all denormalizations and repair any inconsistencies"
  task :denormalize => :environment do
    errors = []
    denormalized_associations.each do |klass, associations|
      associations.each do |association|
        method = "denormalize_#{association}"
        debug "Denormalizing #{klass}##{method}\n"
        klass.all.each do |item|
          begin
            item.send(method)
            item.save
            debug "."
          rescue
            errors << "#{item} (#{method})"
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
      ApplicationInstance => %w(from_application),
      Cronjob             => %w(from_server),
      PhysicalRack        => %w(from_site),
      Server              => %w(from_physical_rack from_maintainer from_operating_system),
      Tomcat              => %w(from_server)
    }
  end
end

