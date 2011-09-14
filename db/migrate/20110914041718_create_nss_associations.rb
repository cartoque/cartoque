class CreateNssAssociations < ActiveRecord::Migration
  def change
    create_table :nss_associations do |t|
      t.integer :nss_volume_id
      t.integer :server_id
      t.timestamps
    end
  end
end
