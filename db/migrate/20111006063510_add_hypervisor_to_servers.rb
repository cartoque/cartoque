class AddHypervisorToServers < ActiveRecord::Migration
  def change
    add_column :servers, :hypervisor_id, :integer
  end
end
