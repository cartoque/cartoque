class AddDefaultValueForUsersProvider < ActiveRecord::Migration
  def up
    change_column :users, :provider, :string, :default => "internal"
  end

  def down
    change_column :users, :provider, :string, :default => nil
  end
end
