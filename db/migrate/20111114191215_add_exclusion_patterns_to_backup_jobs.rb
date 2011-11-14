class AddExclusionPatternsToBackupJobs < ActiveRecord::Migration
  def change
    add_column :backup_jobs, :exclusion_patterns, :string
  end
end
