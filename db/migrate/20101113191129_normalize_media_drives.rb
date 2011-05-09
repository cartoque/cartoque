class NormalizeMediaDrives < ActiveRecord::Migration
  def self.up
    rename_table :cddvd, :media_drives
    rename_column :machines, :cddvd_id, :media_drive_id
    rename_column :media_drives, :cd_dvd, :nom
    MediaDrive.delete_all(:nom => "--")
  end

  def self.down
    MediaDrive.create(:nom => "--")
    rename_column :media_drives, :nom, :cddvd
    rename_column :machines, :media_drive_id, :cddvd_id
    rename_table :media_drives, :cddvd
  end
end
