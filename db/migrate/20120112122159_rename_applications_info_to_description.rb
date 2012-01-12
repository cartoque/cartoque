class RenameApplicationsInfoToDescription < ActiveRecord::Migration
  def change
    rename_column :applications, :info, :description
  end
end
