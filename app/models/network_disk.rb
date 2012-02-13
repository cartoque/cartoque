class NetworkDisk < ActiveRecord::Base
  belongs_to :server
  belongs_to :client, class_name: 'Server'

  validates_presence_of :server, :client
end
