class MakeApplicationsInfoLongText < ActiveRecord::Migration
  def up
    change_column :applications, :info, :text
  end

  def down
    change_column :applications, :info, :string
  end
end
