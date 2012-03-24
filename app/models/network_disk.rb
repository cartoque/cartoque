class NetworkDisk
  include Mongoid::Document
  include Mongoid::Timestamps

  field :server_directory, type: String
  field :client_mountpoint, type: String
  belongs_to :server, class_name: 'MongoServer', inverse_of: :exported_disks
  belongs_to :client, class_name: 'MongoServer', inverse_of: :network_filesystems

  validates_presence_of :server, :client
end
