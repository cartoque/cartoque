class CreateNssDisks < ActiveRecord::Migration
  def change
    create_table :nss_disks do |t|
      t.string :name
      t.string :wwid
      t.string :falconstor_type
      t.integer :server_id
      t.integer :owner_id
      t.string :category
      t.string :guid
      t.string :fsid
      t.integer :size, :limit => 8
      t.timestamps
    end
  end
end
