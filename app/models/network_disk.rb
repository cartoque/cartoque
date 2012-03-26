class NetworkDisk
  include Mongoid::Document
  include Mongoid::Timestamps

  field :server_directory, type: String
  field :client_mountpoint, type: String
  belongs_to :server, inverse_of: :exported_disks
  belongs_to :client, class_name: 'Server', inverse_of: :network_filesystems

  validates_presence_of :server, :client
end
