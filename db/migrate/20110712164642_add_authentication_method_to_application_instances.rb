class AddAuthenticationMethodToApplicationInstances < ActiveRecord::Migration
  def self.up
    add_column :application_instances, :authentication_method, :string
    ApplicationInstance.all.each do |app_instance|
      if app_instance.name == "prod" && app_instance.application.cerbere
        app_instance.update_attribute("authentication_method", "cerbere")
      else
        app_instance.update_attribute("authentication_method", "none")
      end
    end
  end

  def self.down
    remove_column :application_instances, :authentication_method
  end
end
