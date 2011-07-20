class AddPublicAttributeToApplicationUrls < ActiveRecord::Migration
  def self.up
    add_column :application_urls, :public, :boolean, :default => true
  end

  def self.down
    remove_column :application_urls, :public
  end
end
