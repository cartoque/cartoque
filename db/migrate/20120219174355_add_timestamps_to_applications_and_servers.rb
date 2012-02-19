class AddTimestampsToApplicationsAndServers < ActiveRecord::Migration
  def change
    add_column :applications, :created_at, :datetime
    add_column :applications, :updated_at, :datetime
    add_column :servers, :created_at, :datetime
    add_column :servers, :updated_at, :datetime
  end
end
