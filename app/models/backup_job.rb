class BackupJob < ActiveRecord::Base
  belongs_to :server

  validates_presence_of :server, :hierarchy
end
