# temp class for active_record versions of objects
class ARBackupException < ActiveRecord::Base
  self.table_name = "backup_exceptions"
end

# migration!
class MigrateBackupExceptionsToMongoid < ActiveRecord::Migration
  def up
    add_column :backup_exceptions_servers, :backup_exception_mongo_id, :string
    BackupException.destroy_all
    cols = ARBackupException.column_names - %w(id)
    ARBackupException.all.each do |job|
      attrs = job.attributes.slice(*cols)
      mjob = BackupException.create(attrs)
      ActiveRecord::Base.connection.execute(
        "UPDATE backup_exceptions_servers SET backup_exception_mongo_id='#{mjob.to_param}' WHERE backup_exception_id = #{job.id}"
      )
    end
  end

  def down
    remove_column :backup_exceptions_servers, :backup_exception_mongo_id
    #nothing else for now! maybe a bit of cleanup later?
  end
end
