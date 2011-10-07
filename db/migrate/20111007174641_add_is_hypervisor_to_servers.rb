class AddIsHypervisorToServers < ActiveRecord::Migration
  def change
    add_column :servers, :is_hypervisor, :boolean
  end
end
