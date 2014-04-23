class RenameBackupExceptionToExclusion < Mongoid::Migration
  def self.up
    database = Mongoid.default_session
    if database.collections.map(&:name).include? 'backup_exceptions'
      database.drop_collection('exclusions')
      database.rename_collection('backup_exceptions', 'exclusions')
      Exclusion.update_all(_type: 'BackupExclusion')
    end
  end

  def self.down
  end
end
