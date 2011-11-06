class BackupJob < ActiveRecord::Base
  belongs_to :server

  scope :by_server, proc{ |server_id| where(:server_id => server_id) }

  validates_presence_of :server, :hierarchy
end
