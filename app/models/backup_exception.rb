class BackupException < ActiveRecord::Base
  has_and_belongs_to_many :servers

  def user_id=(user_id)
    self.user_mongo_id = user_id.to_s
  end

  def user
    User.find(self.user_mongo_id) rescue nil
  end
end
