class RemoveCriticityFromApplications < ActiveRecord::Migration
  def up
    remove_column :applications, :criticity
  end

  def down
    add_column :applications, :criticity, :integer
  end
end
