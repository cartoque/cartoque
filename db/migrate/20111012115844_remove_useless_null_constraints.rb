class RemoveUselessNullConstraints < ActiveRecord::Migration
  def up
    change_column :applications, :info, :string, null: nil
    change_column :servers, :description, :string, null: nil
  end

  def down
    #again, no down side because these constraints 
    #shouldn't be re-introduced, they break tests on sqlite3
  end
end
