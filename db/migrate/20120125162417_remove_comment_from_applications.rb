class RemoveCommentFromApplications < ActiveRecord::Migration
  def up
    remove_column :applications, :comment
  end

  def down
    add_column :applications, :comment, :text
  end
end
