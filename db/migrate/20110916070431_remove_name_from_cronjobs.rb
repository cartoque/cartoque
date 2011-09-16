class RemoveNameFromCronjobs < ActiveRecord::Migration
  def up
    remove_column :cronjobs, :name
  end

  def down
    add_column :cronjobs, :name, :string
  end
end
