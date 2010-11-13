class NormalizeServices < ActiveRecord::Migration
  def self.up
    rename_column :services, :service_titre, :nom
    Service.where(:nom => "-").each(&:destroy)
  end

  def self.down
    Service.create(:nom => "-")
    rename_column :services, :nom, :service_titre
  end
end
