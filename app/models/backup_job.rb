class BackupJob < ActiveRecord::Base
  belongs_to :server

  scope :by_server, proc{ |term| joins(:server).where("servers.name like ?", "%#{term}%") }
  scope :by_client_type, proc{ |client_type| where(client_type: client_type) }

  validates_presence_of :server, :hierarchy
end
