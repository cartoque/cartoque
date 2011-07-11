class CreateApplicationUrls < ActiveRecord::Migration
  def self.up
    create_table :application_urls do |t|
      t.string :url
      t.integer :application_instance_id
      t.timestamps
    end
  end

  def self.down
    drop_table :application_urls
  end
end
