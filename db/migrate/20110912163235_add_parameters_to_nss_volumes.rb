class AddParametersToNssVolumes < ActiveRecord::Migration
  def change
    add_column :nss_volumes, :snapshot_enabled, :boolean, :default => false
    add_column :nss_volumes, :timemark_enabled, :boolean, :default => false
    add_column :nss_volumes, :falconstor_id, :integer
    add_column :nss_volumes, :guid, :string
    add_column :nss_volumes, :falconstor_type, :string
    add_column :nss_volumes, :dataset_guid, :string
    remove_column :nss_volumes, :attrs
  end
end
