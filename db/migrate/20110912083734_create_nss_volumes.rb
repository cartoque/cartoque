class CreateNssVolumes < ActiveRecord::Migration
  def change
    create_table :nss_volumes do |t|
      t.string  :name
      t.integer :server_id
      t.integer :size, :limit => 8
      t.text    :attrs
      t.timestamps
    end
  end
end
