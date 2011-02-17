class AddIdentifierToApplications < ActiveRecord::Migration
  def self.up
    add_column :applications, :identifier, :string
    Application.all.each do |application|
      application.identifier = application.nom.parameterize unless application.identifier
      application.save
    end
  end

  def self.down
    remove_column :applications, :identifier
  end
end
