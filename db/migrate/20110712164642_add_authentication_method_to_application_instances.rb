class AddAuthenticationMethodToApplicationInstances < ActiveRecord::Migration
  def self.up
    add_column :application_instances, :authentication_method, :string
  end

  def self.down
    remove_column :application_instances, :authentication_method
  end
end
