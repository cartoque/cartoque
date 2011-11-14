class RemoveClientVersionFromBackupJobs < ActiveRecord::Migration
  def up
    remove_column :backup_jobs, :client_version
  end

  def down
    add_column :backup_jobs, :client_version, :string
  end
end
