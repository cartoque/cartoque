class AddIdentifierToApplications < ActiveRecord::Migration
  def self.up
    add_column :applications, :identifier, :string
  end

  def self.down
    remove_column :applications, :identifier
  end
end
