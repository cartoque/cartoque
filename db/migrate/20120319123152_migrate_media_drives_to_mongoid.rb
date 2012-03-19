# temp class for active_record versions of objects
class ARMediaDrive < ActiveRecord::Base
  self.table_name = "media_drives"
end

# migration!
class MigrateMediaDrivesToMongoid < ActiveRecord::Migration
  def up
    add_column :servers, :media_drive_mongo_id, :string
    MediaDrive.destroy_all
    cols = ARMediaDrive.column_names - %w(id)
    ARMediaDrive.all.each do |media_drive|
      attrs = media_drive.attributes.slice(*cols)
      mdrive = MediaDrive.create(attrs)
      ActiveRecord::Base.connection.execute("UPDATE servers SET media_drive_mongo_id='#{mdrive.to_param}' WHERE media_drive_id = #{media_drive.id}")
    end
  end

  def down
    remove_column :servers, :media_drive_mongo_id
    #nothing for now! maybe a bit of cleanup later?
  end
end
