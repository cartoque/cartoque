class NssVolume < ActiveRecord::Base
  belongs_to :server
  has_many :nss_associations, dependent: :destroy
  has_many :clients, through: :nss_associations, source: :server

  validates_presence_of :name

  scope :by_server, proc { |server_id| where(server_id: server_id) }
  scope :by_name, proc { |search| where("nss_volumes.name LIKE ?", "%#{search}%") }
  scope :by_client, proc { |client_id| joins(:clients).where("nss_associations.server_id" => client_id) }
  scope :by_type, proc { |type| where(falconstor_type: type) }
  scope :by_guid, proc { |search| where("guid LIKE ?", "%#{search}%") }
  scope :by_snapshot_status, proc { |status| where(snapshot_enabled: status) }
end
