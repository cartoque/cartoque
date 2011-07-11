class CreateInstancesFromApplicationPeField < ActiveRecord::Migration
  def self.up
    Application.reset_column_information
    Application.all.each do |application|
      ApplicationInstance.find_or_create_by_name_and_application_id("prod", application.id)
      ApplicationInstance.find_or_create_by_name_and_application_id("ecole", application.id) if application.read_attribute(:pe).include?("E")
    end
  end

  def self.down
  end
end
