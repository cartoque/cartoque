class RemoveSeenOnFromUsers < ActiveRecord::Migration
  def up
    begin
      User.where("last_sign_in_at IS NULL and seen_on IS NOT NULL").each do |user|
        user.update_attribute(:last_sign_in_at, user.read_attribute(:seen_on))
      end
    rescue
    end
    remove_column :users, :seen_on
  end

  def down
    add_column :users, :seen_on, :date
  end
end
