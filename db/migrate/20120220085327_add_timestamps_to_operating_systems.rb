class AddTimestampsToOperatingSystems < ActiveRecord::Migration
  def change
    add_column :operating_systems, :created_at, :datetime
    add_column :operating_systems, :updated_at, :datetime
  end
end
