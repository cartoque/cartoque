class CreateBackupJobs < ActiveRecord::Migration
  def change
    create_table :backup_jobs do |t|
      t.string :hierarchy
      t.string :client_type
      t.string :client_version
      t.string :catalog
      t.integer :server_id
      t.timestamps
    end
  end
end
