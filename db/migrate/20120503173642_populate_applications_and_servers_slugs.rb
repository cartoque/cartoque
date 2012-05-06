class PopulateApplicationsAndServersSlugs < Mongoid::Migration
  def self.up
    Application.all.each do |app|
      app.send(:generate_slug!)
      app.save
    end
    Server.all.each do |srv|
      srv.send(:generate_slug!)
      srv.save
      srv.unset(:ci_identifier)
    end
  end

  def self.down
  end
end
