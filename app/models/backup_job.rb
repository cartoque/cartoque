class BackupJob < ActiveRecord::Base
  belongs_to :server

  scope :by_server, proc{ |server_id| where(:server_id => server_id) }
  scope :by_client_type, proc{ |client_type| where(:client_type => client_type) }

  validates_presence_of :server, :hierarchy
end
