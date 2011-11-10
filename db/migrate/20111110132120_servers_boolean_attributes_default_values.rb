class ServersBooleanAttributesDefaultValues < ActiveRecord::Migration
  def up
    change_column :servers, :network_device, :boolean, :null => false, :default => false
    change_column :servers, :is_hypervisor,  :boolean, :null => false, :default => false
  end

  def down
    #we don't want to go back to previous default values...
  end
end
