class AddSeenOnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :seen_on, :date
  end
end
