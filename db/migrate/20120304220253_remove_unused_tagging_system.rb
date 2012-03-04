class RemoveUnusedTaggingSystem < ActiveRecord::Migration
  def up
    drop_table :taggings if table_exists?(:taggings)
    drop_table :tags if table_exists?(:tags)
  end

  def down
    #nothing, we never used it hey!
  end
end
