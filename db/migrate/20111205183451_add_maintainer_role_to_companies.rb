class AddMaintainerRoleToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :is_maintainer, :boolean, default: false
  end
end
