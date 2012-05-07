class RenameBackupExceptionToExclusion < Mongoid::Migration
  def self.up
    if Mongoid.database.collections.map(&:name).include? 'backup_exceptions'
      Mongoid.database.drop_collection('exclusions')
      Mongoid.database.rename_collection('backup_exceptions', 'exclusions')
      Exclusion.update_all(_type: 'BackupExclusion')
    end
  end

  def self.down
  end
end
