class MakeApplicationsCommentLongText < ActiveRecord::Migration
  def up
    change_column :applications, :comment, :text
  end

  def down
    change_column :applications, :comment, :string
  end
end
