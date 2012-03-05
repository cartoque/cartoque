class RemoveUnusedSousreseauxTable < ActiveRecord::Migration
  def up
    drop_table :sousreseaux
  end

  def down
    #we never used that one...
  end
end
